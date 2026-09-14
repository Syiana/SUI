local Module = SUI:NewModule("RaidFrames.Auras");

-- Our own buff, debuff and defensive rows on the Blizzard party and raid frames.
--
-- Blizzard's own rows sit behind three character cvars, and ours stand in for them, so they get
-- switched off while we draw. What we took is remembered per character and handed straight back
-- the moment our rows stop: a cvar outlives the addon that set it, and a player who turns this
-- off - or uninstalls SUI - would otherwise be left with raid frames that never show an aura
-- again, with nothing in the Blizzard interface options to explain why.
local BLIZZARD_AURA_CVARS = {
    "raidFramesDisplayBuffs",
    "raidFramesDisplayDebuffs",
    "raidFramesCenterBigDefensive"
}

-- Icons take a share of the frame's height rather than a pixel size, because a party frame and a
-- 40-man raid frame are nowhere near the same size. This is the height one falls back to before
-- the client has said how tall the frame is.
local FALLBACK_FRAME_HEIGHT = 36
local ICON_GAP = 2

-- Icon budgets per side. The engine pools one button per slot, so these are the ceiling the
-- profile's own limits are capped against, not the number actually drawn.
local MAX_BUFFS = 6
local MAX_DEBUFFS = 6
local MAX_LEAD_DEBUFFS = 2
local MAX_DEFENSIVES = 3

-- Boss and role debuffs lead the debuff row a little larger than the rest of it, the way the
-- default frames enlarge them.
local LEAD_DEBUFF_SCALE = 1.3

-- Countdown numbers are only drawn where the icon has the room for them. A raid buff icon is
-- about twelve pixels, and a countdown on one of those is a smudge.
local COUNTDOWN_MIN_SIZE = 18

local GLOSS_TEXTURE = [[Interface\Addons\SUI\Media\Textures\Core\gloss]]
local BORDER_TEXTURE = [[Interface\Addons\SUI\Media\Textures\Core\gloss_border_w]]
local SHADOW_TEXTURE = [[Interface\Addons\SUI\Media\Textures\Core\outer_shadow]]

-- Every compact frame we have built rows on, keyed by frame, so a frame the client re-points at
-- another unit is found again rather than built twice.
local tracked = {}

-- Bumped by every config change. A frame carrying an older stamp is re-applied on its next pass,
-- which keeps the per-frame work to "has anything actually moved" the rest of the time.
local revision = 1

local function SafeCall(object, method, ...)
    if object and object[method] then
        return pcall(object[method], object, ...)
    end

    return false
end

local function Settings()
    local db = SUI.db and SUI.db.profile.raidframes
    return db and db.auras
end

local function Enabled()
    local settings = Settings()
    return settings ~= nil and settings.enabled == true
end

----------------------------------------------------------------------------------------------
-- Blizzard's rows
----------------------------------------------------------------------------------------------

-- Flipping one of these rebuilds the raid frames, which the client refuses to do mid-fight, so a
-- change asked for in combat waits for the end of it.
local pendingCVarState

local function CVarLedger()
    SUI.db.char.raidauracvars = SUI.db.char.raidauracvars or {}
    return SUI.db.char.raidauracvars
end

local function WriteBlizzardAuras(show)
    local ledger = CVarLedger()
    local value = show and "1" or "0"

    for _, cvar in ipairs(BLIZZARD_AURA_CVARS) do
        -- Handing back a row we never took would switch on something the player turned off
        -- themselves, so the recorded take is what licenses the hand-back.
        if not show or ledger[cvar] then
            if GetCVar(cvar) ~= value then
                pcall(SetCVar, cvar, value)
            end

            ledger[cvar] = (not show) or nil
        end
    end
end

function Module:RefreshBlizzardAuras()
    local show = not Enabled()

    if InCombatLockdown() then
        pendingCVarState = show
        return
    end

    pendingCVarState = nil
    WriteBlizzardAuras(show)
end

----------------------------------------------------------------------------------------------
-- Filters
----------------------------------------------------------------------------------------------

local function FilterString(...)
    if not AuraUtil or type(AuraUtil.CreateFilterString) ~= "function" then
        return nil
    end

    local ok, filter = pcall(AuraUtil.CreateFilterString, ...)
    return ok and filter or nil
end

local function DefensivesShown()
    local settings = Settings()
    local mode = settings and settings.defensives and settings.defensives.mode or "big"

    return mode ~= "hide"
end

-- Which buffs count as worth a slot, kept apart from who cast them because the two questions are
-- independent: a healer wants their own hots, a tank wants the raid buffs, and both want the
-- answer narrowed the same way.
--
-- RAID is the game's own pick - the set the default raid frames draw and nothing else - so
-- "important only" costs us no spell list and stays current on its own. IMPORTANT is the newer
-- category flag and is the stricter of the two.
local BUFF_SCOPE_TOKENS = {
    raid = "RAID",
    important = "IMPORTANT"
}

-- Buffs: everything, or only what the player cast themselves. The defensive tokens are negated
-- while the defensive row is up, so a shield is never drawn twice on the same frame.
local function BuffFilter()
    local settings = Settings()
    local buffs = settings and settings.buffs
    local mode = buffs and buffs.mode or "mine"
    local scope = BUFF_SCOPE_TOKENS[buffs and buffs.filter or "raid"]
    local tokens = { "HELPFUL" }

    if mode == "mine" then
        tokens[#tokens + 1] = "PLAYER"
    end

    if scope then
        tokens[#tokens + 1] = scope
    end

    if DefensivesShown() then
        tokens[#tokens + 1] = "!BIG_DEFENSIVE"
        tokens[#tokens + 1] = "!EXTERNAL_DEFENSIVE"
    end

    return FilterString(unpack(tokens))
end

-- Whether the buff row is asking the engine something it can only answer for a unit the client is
-- drawing: who cast an aura, or which category it falls in. The game's own raid pick is neither,
-- so that one keeps working across the room. See AuraDataState.
local function BuffsNeedVisibleUnit()
    local settings = Settings()
    local buffs = settings and settings.buffs

    return (buffs and buffs.mode or "mine") == "mine" or (buffs and buffs.filter) == "important"
end

-- Debuffs: everything, or narrowed to what somebody in the group can actually take off.
local function DebuffFilter()
    local settings = Settings()
    local mode = settings and settings.debuffs and settings.debuffs.mode or "all"

    if mode == "dispellable" then
        return FilterString("HARMFUL", "DISPELLABLE")
    end

    return FilterString("HARMFUL")
end

local function DefensiveFilter(external)
    if external then
        return FilterString("HELPFUL", "EXTERNAL_DEFENSIVE", "!BIG_DEFENSIVE")
    end

    return FilterString("HELPFUL", "BIG_DEFENSIVE")
end

-- Icon counts. A side switched off keeps its group and is budgeted to zero, so flipping it back
-- on does not need a reload to get its buttons back.
local function BuffCount()
    local settings = Settings()
    local buffs = settings and settings.buffs

    if not buffs or buffs.mode == "hide" then
        return 0
    end

    return math.min(math.max(tonumber(buffs.max) or MAX_BUFFS, 1), MAX_BUFFS)
end

local function DebuffCount()
    local settings = Settings()
    local debuffs = settings and settings.debuffs

    if not debuffs or debuffs.mode == "hide" then
        return 0
    end

    return math.min(math.max(tonumber(debuffs.max) or 3, 1), MAX_DEBUFFS)
end

local function LeadDebuffCount()
    local settings = Settings()
    local debuffs = settings and settings.debuffs

    if not debuffs or debuffs.mode == "hide" or debuffs.lead == false then
        return 0
    end

    return MAX_LEAD_DEBUFFS
end

local function DefensiveCount(external)
    local settings = Settings()
    local mode = settings and settings.defensives and settings.defensives.mode or "big"

    if mode == "hide" then
        return 0
    end

    if external and mode ~= "all" then
        return 0
    end

    return MAX_DEFENSIVES
end

----------------------------------------------------------------------------------------------
-- Sizes and placement
----------------------------------------------------------------------------------------------

local function FrameHeight(frame)
    local height = frame and frame:GetHeight()

    if not height or height < 1 then
        return FALLBACK_FRAME_HEIGHT
    end

    return height
end

local function PercentSize(height, percent, fallback)
    percent = tonumber(percent) or fallback

    return math.max(math.floor(height * percent / 100 + 0.5), 6)
end

local function IconSizes(frame)
    local settings = Settings()
    local height = FrameHeight(frame)
    local buffs = settings and settings.buffs
    local debuffs = settings and settings.debuffs
    local defensives = settings and settings.defensives

    return PercentSize(height, buffs and buffs.size, 33),
        PercentSize(height, debuffs and debuffs.size, 55),
        PercentSize(height, defensives and defensives.size, 60)
end

-- The buff row hangs off one bottom corner and the debuff row off the other; which is which is
-- the one thing the player picks, and everything else follows from it.
local function BuffCorner()
    local settings = Settings()
    local point = settings and settings.buffs and settings.buffs.point

    return point == "BOTTOMLEFT" and "BOTTOMLEFT" or "BOTTOMRIGHT"
end

-- Rows sit above the power bar on a frame that shows one, and on the frame's own edge where it
-- does not, so they never cover the mana of a healer somebody is watching.
local function CornerAnchor(frame, corner)
    local powerBar = frame.powerBar
    local hasPower = powerBar and powerBar:IsShown()
    local reference = hasPower and powerBar or frame
    local left = corner == "BOTTOMLEFT"
    local relativePoint

    if hasPower then
        relativePoint = left and "TOPLEFT" or "TOPRIGHT"
    else
        relativePoint = corner
    end

    return reference, relativePoint, left and 2 or -2, hasPower and 1 or 2
end

local function ApplyRowPlacement(frame, container, corner)
    local reference, relativePoint, x, y = CornerAnchor(frame, corner)
    local left = corner == "BOTTOMLEFT"

    container:ClearAllPoints()
    container:SetPoint(corner, reference, relativePoint, x, y)
    SafeCall(container, "SetFlowLayoutAnchorPoint", corner)
    SafeCall(container, "SetFlowLayoutGrowthDirection",
        left and AnchorUtil.FlowDirection.Right or AnchorUtil.FlowDirection.Left,
        AnchorUtil.FlowDirection.Up)
end

local DEFENSIVE_POINTS = {
    CENTER = true,
    LEFT = true,
    RIGHT = true
}

local function ApplyDefensivePlacement(frame, container)
    local settings = Settings()
    local defensives = settings and settings.defensives
    local point = defensives and defensives.point or "CENTER"

    if not DEFENSIVE_POINTS[point] then
        point = "CENTER"
    end

    local x = tonumber(defensives and defensives.x) or 0
    local y = tonumber(defensives and defensives.y) or 0

    container:ClearAllPoints()
    container:SetPoint(point, frame, point, x, y)
    SafeCall(container, "SetFlowLayoutAnchorPoint", point)
    SafeCall(container, "SetFlowLayoutGrowthDirection",
        point == "RIGHT" and AnchorUtil.FlowDirection.Left or AnchorUtil.FlowDirection.Right,
        AnchorUtil.FlowDirection.Down)
end

----------------------------------------------------------------------------------------------
-- Buttons
----------------------------------------------------------------------------------------------

local function StyleAuraButton(auraFrame, size, isDebuff)
    auraFrame:SetSize(size, size)

    if not auraFrame.Icon then
        auraFrame.Icon = auraFrame:CreateTexture(nil, "BACKGROUND")
        auraFrame.Icon:SetAllPoints(auraFrame)
        auraFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        auraFrame:SetIcon(auraFrame.Icon)
    end

    if not auraFrame.Cooldown then
        auraFrame.Cooldown = CreateFrame("Cooldown", nil, auraFrame, "CooldownFrameTemplate")
        auraFrame.Cooldown:SetAllPoints(auraFrame.Icon)
        auraFrame.Cooldown:SetDrawBling(false)
        auraFrame.Cooldown:SetReverse(true)
        auraFrame.Cooldown:SetHideCountdownNumbers(size < COUNTDOWN_MIN_SIZE)
        SafeCall(auraFrame.Cooldown, "SetCountdownFont", "NumberFontNormalSmall")
        auraFrame:SetDurationCooldown(auraFrame.Cooldown)
    end

    -- The cooldown swipe is a child frame and draws over anything on the button itself, so the
    -- borders and the stack count live on an overlay one level above it.
    if not auraFrame.SUIOverlay then
        auraFrame.SUIOverlay = CreateFrame("Frame", nil, auraFrame)
        auraFrame.SUIOverlay:SetAllPoints(auraFrame)
        auraFrame.SUIOverlay:SetFrameLevel(auraFrame.Cooldown:GetFrameLevel() + 1)
    end

    if not auraFrame.SUIBorder then
        local border = auraFrame.SUIOverlay:CreateTexture(nil, "OVERLAY", nil, 1)
        border:SetTexture(GLOSS_TEXTURE)
        border:SetTexCoord(0, 1, 0, 1)
        border:SetPoint("TOPLEFT", auraFrame, "TOPLEFT", -1, 1)
        border:SetPoint("BOTTOMRIGHT", auraFrame, "BOTTOMRIGHT", 1, -1)
        border:SetVertexColor(unpack(SUI:Color(0.15) or { 0.15, 0.15, 0.15, 1 }))
        auraFrame.SUIBorder = border

        local shadow = CreateFrame("Frame", nil, auraFrame, "BackdropTemplate")
        shadow:SetPoint("TOPLEFT", auraFrame, "TOPLEFT", -4, 4)
        shadow:SetPoint("BOTTOMRIGHT", auraFrame, "BOTTOMRIGHT", 4, -4)
        shadow:SetFrameLevel(math.max(auraFrame:GetFrameLevel() - 1, 0))
        shadow:SetBackdrop({
            edgeFile = SHADOW_TEXTURE,
            edgeSize = 4,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        shadow:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9) or { 0, 0, 0, 0.9 }))
        auraFrame.SUIShadow = shadow
    end

    -- Debuffs get a second border the engine colours by dispel type on its own. Letting it drive
    -- the colour beats splitting the row into one group per school, the way the target frame has
    -- to, and it keeps curses purple without a colour table of our own.
    if isDebuff and not auraFrame.SUIDispelBorder then
        local dispel = auraFrame.SUIOverlay:CreateTexture(nil, "OVERLAY", nil, 2)
        dispel:SetTexture(BORDER_TEXTURE)
        dispel:SetTexCoord(0, 1, 0, 1)
        dispel:SetDesaturated(true)
        dispel:SetPoint("TOPLEFT", auraFrame, "TOPLEFT", -2, 2)
        dispel:SetPoint("BOTTOMRIGHT", auraFrame, "BOTTOMRIGHT", 2, -2)
        auraFrame.SUIDispelBorder = dispel

        local applied = SafeCall(auraFrame, "SetAuraBorder", dispel, {
            showIcon = false,
            showWhenHarmful = true,
            showWhenHelpful = false,
            showWithoutDispelType = true,
            style = AuraButtonBorderStyle and AuraButtonBorderStyle.Color or nil
        })

        -- A build without the border API still gets a debuff ring, just an uncoloured one.
        if not applied then
            dispel:SetVertexColor(0.8, 0, 0, 1)
        end
    end

    if not auraFrame.Count then
        auraFrame.Count = auraFrame.SUIOverlay:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
        auraFrame.Count:SetFont(STANDARD_TEXT_FONT, math.max(math.floor(size / 2.6), 8), "OUTLINE")
        auraFrame.Count:SetPoint("BOTTOMRIGHT", auraFrame.Icon, "BOTTOMRIGHT", 1, -1)
        auraFrame:SetApplicationCount(auraFrame.Count)
    end
end

local function TooltipsEnabled()
    local settings = Settings()

    return not settings or settings.tooltips ~= false
end

local function RegisterButton(data, auraFrame)
    data.buttons[#data.buttons + 1] = auraFrame
    SafeCall(auraFrame, "SetMouseMotionEnabled", TooltipsEnabled())
end

----------------------------------------------------------------------------------------------
-- Containers
----------------------------------------------------------------------------------------------

-- Above the health bar rather than the frame, because the bar carries its own level and icons
-- sitting under a health bar are icons nobody can read.
local function NewContainer(frame, level)
    local base = frame:GetFrameLevel()
    if frame.healthBar then
        base = math.max(base, frame.healthBar:GetFrameLevel())
    end

    local container = CreateFrame("AuraContainer", nil, frame, "CustomAuraContainerTemplate")
    container:SetSize(1, 1)
    container:SetFrameLevel(math.max(base + level, 0))
    container:SetEnabled(false)

    return container
end

local function BuildContainers(frame)
    local buffFilter, debuffFilter = BuffFilter(), DebuffFilter()

    -- No filter string means a client that does not know these tokens, and a group built without
    -- one shows everything or errors outright. Better to leave the frame alone.
    if not buffFilter or not debuffFilter or not DefensiveFilter(false) then
        return nil
    end

    local buffSize, debuffSize, defensiveSize = IconSizes(frame)
    local data = {
        buttons = {},
        base = {
            buffs = buffSize,
            debuffs = debuffSize,
            defensives = defensiveSize
        }
    }

    local layout = {
        elementSpacing = ICON_GAP,
        lineSpacing = ICON_GAP
    }

    data.buffs = NewContainer(frame, 4)
    data.buffs:AddAuraGroup("Buffs", buffFilter, {
        maxFrameCount = MAX_BUFFS,
        candidateFilters = { isFriendly = true },
        initializeFrame = function(auraFrame)
            StyleAuraButton(auraFrame, buffSize, false)
            RegisterButton(data, auraFrame)
        end,
        layout = layout
    })

    data.debuffs = NewContainer(frame, 6)
    -- Boss and role auras lead the row and everything else follows them: the same split the
    -- default frames make when they enlarge a mechanic you have to react to.
    data.debuffs:AddAuraGroup("DebuffsLead", debuffFilter, {
        maxFrameCount = MAX_LEAD_DEBUFFS,
        candidateFilters = { isBossOrRoleAura = true, isFriendly = true },
        initializeFrame = function(auraFrame)
            StyleAuraButton(auraFrame, math.floor(debuffSize * LEAD_DEBUFF_SCALE + 0.5), true)
            RegisterButton(data, auraFrame)
        end,
        layout = layout
    })
    data.debuffs:AddAuraGroup("Debuffs", debuffFilter, {
        maxFrameCount = MAX_DEBUFFS,
        candidateFilters = { isBossOrRoleAura = false, isFriendly = true },
        initializeFrame = function(auraFrame)
            StyleAuraButton(auraFrame, debuffSize, true)
            RegisterButton(data, auraFrame)
        end,
        layout = layout
    })

    data.defensives = NewContainer(frame, 8)
    data.defensives:AddAuraGroup("Defensives", DefensiveFilter(false), {
        maxFrameCount = MAX_DEFENSIVES,
        candidateFilters = { isFriendly = true },
        initializeFrame = function(auraFrame)
            StyleAuraButton(auraFrame, defensiveSize, false)
            RegisterButton(data, auraFrame)
        end,
        layout = layout
    })
    -- Externals are a group of their own so "major only" can budget them to zero rather than
    -- rebuild the row. A client that does not know the token simply never gets the group, and the
    -- setting that turns it on has nothing to turn on.
    local externalFilter = DefensiveFilter(true)
    if externalFilter then
        data.externals = true
        data.defensives:AddAuraGroup("DefensivesExternal", externalFilter, {
            maxFrameCount = 0,
            candidateFilters = { isFriendly = true },
            initializeFrame = function(auraFrame)
                StyleAuraButton(auraFrame, defensiveSize, false)
                RegisterButton(data, auraFrame)
            end,
            layout = layout
        })
    end

    tracked[frame] = data

    return data
end

-- Filters, budgets and the line width the rows wrap at. All of it can be re-applied to a live
-- container, so nothing in the config panel needs a reload to take effect.
local function ApplyGroups(frame, data)
    local buffSize, debuffSize, defensiveSize = IconSizes(frame)
    local settings = Settings()
    local perRow = math.min(
        math.max(tonumber(settings and settings.buffs and settings.buffs.perrow) or 3, 1), MAX_BUFFS)
    local leadSize = math.floor(debuffSize * LEAD_DEBUFF_SCALE + 0.5)

    SafeCall(data.buffs, "SetAuraGroupFilterString", "Buffs", BuffFilter())
    SafeCall(data.buffs, "SetAuraGroupMaxFrameCount", "Buffs", BuffCount())
    SafeCall(data.buffs, "SetFlowLayoutMaximumLineSize", perRow * (buffSize + ICON_GAP))

    local debuffFilter = DebuffFilter()
    SafeCall(data.debuffs, "SetAuraGroupFilterString", "DebuffsLead", debuffFilter)
    SafeCall(data.debuffs, "SetAuraGroupFilterString", "Debuffs", debuffFilter)
    SafeCall(data.debuffs, "SetAuraGroupMaxFrameCount", "DebuffsLead", LeadDebuffCount())
    SafeCall(data.debuffs, "SetAuraGroupMaxFrameCount", "Debuffs", DebuffCount())
    -- Measured in the lead icons, since those are the wider ones.
    SafeCall(data.debuffs, "SetFlowLayoutMaximumLineSize",
        (MAX_LEAD_DEBUFFS + DebuffCount()) * (leadSize + ICON_GAP))

    SafeCall(data.defensives, "SetAuraGroupMaxFrameCount", "Defensives", DefensiveCount(false))
    if data.externals then
        SafeCall(data.defensives, "SetAuraGroupMaxFrameCount", "DefensivesExternal", DefensiveCount(true))
    end
    SafeCall(data.defensives, "SetFlowLayoutMaximumLineSize", MAX_DEFENSIVES * (defensiveSize + ICON_GAP))

    -- Buttons are pooled and built once, at the size the frame had then. Scaling the container is
    -- what re-sizes a row a player is dragging a slider through, and what keeps party icons and
    -- raid icons the same share of two very differently sized frames.
    local function Rescale(container, base, wanted)
        if base and base > 0 and wanted and wanted > 0 then
            container:SetScale(wanted / base)
        end
    end

    Rescale(data.buffs, data.base.buffs, buffSize)
    Rescale(data.debuffs, data.base.debuffs, debuffSize)
    Rescale(data.defensives, data.base.defensives, defensiveSize)
end

local function ApplyPlacement(frame, data)
    local buffCorner = BuffCorner()
    local debuffCorner = buffCorner == "BOTTOMLEFT" and "BOTTOMRIGHT" or "BOTTOMLEFT"

    ApplyRowPlacement(frame, data.buffs, buffCorner)
    ApplyRowPlacement(frame, data.debuffs, debuffCorner)
    ApplyDefensivePlacement(frame, data.defensives)
end

local function SetContainerUnit(container, unit)
    if unit then
        container:SetUnit(unit)
        container:SetEnabled(true)
        container:Show()
        container:UpdateAllAuras()
    else
        container:SetEnabled(false)
        container:Hide()
    end
end

local function HideContainers(data)
    if not data then
        return
    end

    data.unit = nil
    for _, key in ipairs({ "buffs", "debuffs", "defensives" }) do
        local container = data[key]
        if container then
            container:SetEnabled(false)
            container:Hide()
        end
    end
end

----------------------------------------------------------------------------------------------
-- Updates
----------------------------------------------------------------------------------------------

local function IsManagedFrame(frame)
    if not frame or frame:IsForbidden() then
        return false
    end

    local name = frame.GetName and frame:GetName()

    return name ~= nil and (name:match("^CompactParty") ~= nil or name:match("^CompactRaid") ~= nil)
end

-- How far a unit's aura data can be trusted, which is not the same answer for all three rows.
--
-- A unit in another phase has none at all, so nothing is drawn for it. A unit outside the world
-- the client is drawing - the other end of a raid, most of a battleground - still reports its
-- auras, but the engine stops weighing the category flags and cannot attribute a caster, so the
-- rows built on those (own buffs, defensives) would fill with whatever the unit happens to have.
-- Plain buffs and debuffs carry neither, and those are exactly the rows a healer needs on
-- somebody they cannot see, so they keep working.
local function AuraDataState(unit)
    local phased = UnitPhaseReason ~= nil and UnitPhaseReason(unit) ~= nil
    local unseen = UnitIsVisible ~= nil and not UnitIsVisible(unit)

    return phased, unseen
end

function Module:UpdateFrame(frame)
    if not IsManagedFrame(frame) then
        return
    end

    local data = tracked[frame]

    if not Enabled() then
        HideContainers(data)
        return
    end

    local unit = frame.displayedUnit or frame.unit
    -- The frames carry a target-of unit each, which nobody wants a second row of auras on.
    if not unit or unit:match("target") then
        HideContainers(data)
        return
    end

    if not data then
        data = BuildContainers(frame)
        if not data then
            return
        end
    end

    local height = FrameHeight(frame)
    local power = (frame.powerBar and frame.powerBar:IsShown()) == true
    local phased, unseen = AuraDataState(unit)

    if data.unit == unit and data.height == height and data.power == power and data.phased == phased and
        data.unseen == unseen and data.revision == revision then
        return
    end

    data.unit = unit
    data.height = height
    data.power = power
    data.phased = phased
    data.unseen = unseen
    data.revision = revision

    ApplyGroups(frame, data)
    ApplyPlacement(frame, data)

    if phased then
        HideContainers(data)
        data.unit = unit
        return
    end

    -- A unit you cannot help - duelling a friendly, mostly - reports no usable defensive state
    -- and the container misreads it, so that row alone sits the situation out.
    local canAssist = UnitCanAssist == nil or UnitCanAssist("player", unit)

    if unseen and BuffsNeedVisibleUnit() then
        SetContainerUnit(data.buffs, nil)
    else
        SetContainerUnit(data.buffs, unit)
    end

    SetContainerUnit(data.debuffs, unit)

    if unseen or not canAssist then
        SetContainerUnit(data.defensives, nil)
    else
        SetContainerUnit(data.defensives, unit)
    end
end

-- Frames the client has built but never re-pointed since we loaded. Cheap enough to walk, and it
-- saves waiting on a roster change to pick up a group that was already formed.
local function ForEachCompactFrame(callback)
    for frame in pairs(tracked) do
        callback(frame)
    end

    for index = 1, 5 do
        callback(_G["CompactPartyFrameMember" .. index])
    end

    for index = 1, MAX_RAID_MEMBERS or 40 do
        callback(_G["CompactRaidFrame" .. index])
    end
end

function Module:UpdateAll()
    ForEachCompactFrame(function(frame)
        if frame then
            Module:UpdateFrame(frame)
        end
    end)
end

-- What the config panel calls. Everything the panel can change is re-appliable, so a setting
-- lands on the frames as the player leaves the slider.
function Module:Refresh()
    revision = revision + 1

    local tooltips = TooltipsEnabled()
    for _, data in pairs(tracked) do
        for _, auraFrame in ipairs(data.buttons) do
            SafeCall(auraFrame, "SetMouseMotionEnabled", tooltips)
        end
    end

    Module:RefreshBlizzardAuras()
    Module:UpdateAll()
end

function Module:OnEnable()
    if not SUI.db.profile.raidframes or not SUI.db.profile.raidframes.auras then
        return
    end

    Module:RefreshBlizzardAuras()

    -- The one call the client makes for every frame it puts a unit on, including the ones it
    -- recycles as a raid re-sorts itself.
    hooksecurefunc("CompactUnitFrame_SetUnit", function(frame)
        Module:UpdateFrame(frame)
    end)

    local events = CreateFrame("Frame")
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:RegisterEvent("GROUP_ROSTER_UPDATE")
    events:RegisterEvent("PLAYER_REGEN_ENABLED")
    events:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_REGEN_ENABLED" and pendingCVarState ~= nil then
            local show = pendingCVarState
            pendingCVarState = nil
            WriteBlizzardAuras(show)
        elseif event == "PLAYER_ENTERING_WORLD" then
            -- Edit Mode writes the same cvars from its own raid frame checkboxes, so a player who
            -- ticked one there gets both rows until we say otherwise.
            Module:RefreshBlizzardAuras()
        end

        C_Timer.After(0.1, function()
            Module:UpdateAll()
        end)
    end)

    -- Phase and visibility decide whether a frame's auras can be trusted, and neither has an
    -- event worth listening to. The pass is a comparison per frame and only does real work where
    -- something moved.
    C_Timer.NewTicker(1, function()
        if not Enabled() or not IsInGroup() then
            return
        end

        for frame in pairs(tracked) do
            Module:UpdateFrame(frame)
        end
    end)
end
