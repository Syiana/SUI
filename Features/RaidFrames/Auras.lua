--[[
    SUI 2.0 - Features/RaidFrames/Auras.lua

    Retail. SUI's buff, debuff and defensive rows on party and raid frames,
    after the in-game tested SUI 1.x auras module: the client's AuraContainer
    (public setters only) draws them, so aura data never reaches Lua and
    Midnight secret values stay inside the client. Blizzard's own rows are
    switched off through their CVars while SUI draws, with a per-character
    ledger that only hands back what SUI took. Also the frame-wide dispel
    highlight.
]]

local _, ns = ...
local SUI = ns.SUI
local RF = ns.RaidFrames

local pairs, max, min, floor, strfind = pairs, math.max, math.min, math.floor, string.find
local CreateFrame, IsInGroup = CreateFrame, IsInGroup
local UnitPhaseReason, UnitIsVisible, UnitCanAssist = UnitPhaseReason, UnitIsVisible, UnitCanAssist
local GetCVar, SetCVar, CanAccess = SUI.Compat.GetCVar, SUI.Compat.SetCVar, SUI.Compat.CanAccess

local MAINLINE = { Mainline = true }

-- Border options for the engine-coloured dispel borders (1.x); the style
-- enum is filled in on load.
local DISPEL_BORDER = { showIcon = false, showWhenHarmful = true, showWhenHelpful = false, showWithoutDispelType = true }
local HIGHLIGHT_BORDER = { showIcon = false, showWhenHarmful = true, showWhenHelpful = false, showWithoutDispelType = false }

local function resolveBorderStyle()
    local style = AuraButtonBorderStyle and AuraButtonBorderStyle.Color
    DISPEL_BORDER.style, HIGHLIGHT_BORDER.style = style, style
end

-- Above the health bar: it carries its own frame level.
local function newContainer(frame, level)
    local base = frame:GetFrameLevel()
    if frame.healthBar then
        base = max(base, frame.healthBar:GetFrameLevel())
    end
    local container = CreateFrame("AuraContainer", nil, frame, "CustomAuraContainerTemplate")
    container:SetSize(1, 1)
    container:SetFrameLevel(base + level)
    container:SetEnabled(false)
    return container
end

local function setContainerUnit(container, unit)
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

-- Dispel highlight ---------------------------------------------------------------------
local Dispel = SUI:NewFeature("RaidFrames.Dispel", {
    category = "raidframes",
    toggle = "auras.dispel",
    clients = MAINLINE,
})

local dispelContainers = setmetatable({}, { __mode = "k" })

-- One invisible aura button per frame; its border is stretched over the
-- whole raid frame and coloured by the client from the dispel type.
local function initDispelButton(auraFrame)
    auraFrame:SetSize(1, 1)
    auraFrame:EnableMouse(false)
    local icon = auraFrame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(1, 1)
    icon:SetAlpha(0)
    auraFrame:SetIcon(icon)

    local raidFrame = auraFrame:GetParent():GetParent()
    local overlay = CreateFrame("Frame", nil, auraFrame)
    overlay:SetAllPoints(raidFrame)
    local border = overlay:CreateTexture(nil, "OVERLAY", nil, 7)
    border:SetAllPoints(overlay)
    local selection = raidFrame.selectionHighlight
    if selection and selection:GetTexture() then
        border:SetTexture(selection:GetTexture())
        border:SetTexCoord(selection:GetTexCoord())
    else
        border:SetTexture(SUI.Media.blank)
        border:SetAlpha(0.3)
    end
    auraFrame:SetAuraBorder(border, HIGHLIGHT_BORDER)
end

function Dispel:OnLoad()
    resolveBorderStyle()
end

function Dispel:Apply(frame)
    local unit = frame.displayedUnit or frame.unit
    local container = dispelContainers[frame]
    if not container then
        container = newContainer(frame, 10)
        container:SetPoint("CENTER", frame, "CENTER")
        container:AddAuraGroup("Dispel", "HARMFUL|DISPELLABLE", {
            maxFrameCount = 1,
            initializeFrame = initDispelButton,
        })
        dispelContainers[frame] = container
    end
    if container.suiUnit ~= unit then
        container.suiUnit = unit
        setContainerUnit(container, unit)
    end
end

RF.On("CompactUnitFrame_SetUnit", Dispel, Dispel.Apply)

function Dispel:OnEnable()
    RF.ForEachFrame(self.Apply, self)
end

function Dispel:OnDisable()
    for _, container in pairs(dispelContainers) do
        container.suiUnit = nil
        setContainerUnit(container, nil)
    end
end

-- Blizzard's rows ------------------------------------------------------------------------
-- A CVar outlives the add-on that set it, so what SUI took is remembered per
-- character and only that is handed back. Flipping them rebuilds the raid
-- frames, which waits for the end of combat.
local BLIZZARD_AURA_CVARS = { "raidFramesDisplayBuffs", "raidFramesDisplayDebuffs", "raidFramesCenterBigDefensive" }
local wantShow -- pending state, nil = nothing queued

local function writeBlizzardAuras()
    local show = wantShow
    wantShow = nil
    if show == nil then
        return
    end
    local ledger = SUI.db.char.raidauracvars
    local value = show and "1" or "0"
    for i = 1, #BLIZZARD_AURA_CVARS do
        local cvar = BLIZZARD_AURA_CVARS[i]
        local current = GetCVar(cvar)
        if current ~= nil and (not show or ledger[cvar]) then
            if current ~= value then
                SetCVar(cvar, value)
            end
            ledger[cvar] = (not show) or nil
        end
    end
end

local function requestBlizzardAuras(show)
    local queued = wantShow ~= nil
    wantShow = show
    if not queued then
        SUI:RunAfterCombat(writeBlizzardAuras)
    end
end

-- Hands back what SUI took when the auras are off at login (profile switch,
-- or a character that last played with them on).
local HandBack = SUI:NewFeature("RaidFrames.AuraHandBack", {
    category = "raidframes",
    toggle = function(db)
        return not db.auras.enabled
    end,
    clients = MAINLINE,
})

function HandBack:OnEnable()
    requestBlizzardAuras(true)
end

-- SUI rows ---------------------------------------------------------------------------------
local Auras = SUI:NewFeature("RaidFrames.Auras", {
    category = "raidframes",
    toggle = "auras.enabled",
    clients = MAINLINE,
})

-- Buttons are built once at a base size; the container scale turns that
-- into the share of the frame height the settings ask for.
local BASE = 20
local LEAD_SCALE = 1.3 -- boss and role debuffs lead the row larger
local LEAD_BASE = floor(BASE * LEAD_SCALE + 0.5)
local GAP = 2
local MAX_BUFFS, MAX_DEBUFFS, MAX_LEAD, MAX_DEFENSIVES = 6, 6, 2, 3
local COUNTDOWN_MIN_SIZE = 18 -- countdown numbers only where they are legible
local FALLBACK_HEIGHT = 36

local LAYOUT = { elementSpacing = GAP, lineSpacing = GAP }
local FRIENDLY = { isFriendly = true }
local LEAD_ONLY = { isBossOrRoleAura = true, isFriendly = true }
local NOT_LEAD = { isBossOrRoleAura = false, isFriendly = true }
local DEFENSIVE_POINTS = { CENTER = true, LEFT = true, RIGHT = true }

local tracked = setmetatable({}, { __mode = "k" }) -- frame -> data (built once per frame)
local revision = 1

-- Settings resolved on enable/refresh; read on the update path.
local buffFilter, debuffFilter = "HELPFUL", "HARMFUL"
local buffCount, debuffCount, leadCount, bigCount, externalCount = 0, 0, 0, 0, 0
local buffsNeedVisible, tooltips = true, true

local function resolve(db)
    local a = db.auras
    local b, d, def = a.buffs, a.debuffs, a.defensives
    local defensivesShown = def.mode ~= "hide"
    local scope = b.filter == "raid" and "RAID" or b.filter == "important" and "IMPORTANT" or nil
    local mine = b.mode == "mine"

    -- Filter strings are the tokens joined by "|" (what AuraUtil.CreateFilterString
    -- builds). Defensive tokens are negated while the defensive row is up, so a
    -- shield is never drawn twice on one frame.
    local filter = mine and "HELPFUL|PLAYER" or "HELPFUL"
    if scope then
        filter = filter .. "|" .. scope
    end
    if defensivesShown then
        filter = filter .. "|!BIG_DEFENSIVE|!EXTERNAL_DEFENSIVE"
    end
    buffFilter = filter
    debuffFilter = d.mode == "dispellable" and "HARMFUL|DISPELLABLE" or "HARMFUL"

    buffCount = b.mode == "hide" and 0 or min(max(b.max, 1), MAX_BUFFS)
    debuffCount = d.mode == "hide" and 0 or min(max(d.max, 1), MAX_DEBUFFS)
    leadCount = (d.mode == "hide" or not d.lead) and 0 or MAX_LEAD
    bigCount = defensivesShown and MAX_DEFENSIVES or 0
    externalCount = def.mode == "all" and MAX_DEFENSIVES or 0
    -- Who cast an aura and its category are only known for units the client
    -- draws; the game's raid pick keeps working across the room.
    buffsNeedVisible = mine or b.filter == "important"
    tooltips = a.tooltips
end

-- Buttons ------------------------------------------------------------------------------------
-- Per-button display switches: countdown only on large enough icons,
-- duration swipe and stack count per row, tooltips.
local function applyButton(auraFrame, container)
    local kind = auraFrame.suiKind
    local settings = SUI.db.profile.raidframes.auras[kind]
    local px = auraFrame.suiBase * (container.suiScale or 1)
    auraFrame.suiCooldown:SetHideCountdownNumbers(px < COUNTDOWN_MIN_SIZE)
    if kind ~= "defensives" then
        auraFrame.suiCooldown:SetAlpha(settings.duration and 1 or 0)
        auraFrame.suiCount:SetAlpha(settings.count and 1 or 0)
    end
    auraFrame:SetMouseMotionEnabled(tooltips)
end

local function styleButton(auraFrame, container, kind, base, isDebuff)
    auraFrame:SetSize(base, base)
    auraFrame.suiKind, auraFrame.suiBase = kind, base

    local icon = auraFrame:CreateTexture(nil, "BACKGROUND")
    icon:SetAllPoints(auraFrame)
    auraFrame:SetIcon(icon)

    local cooldown = CreateFrame("Cooldown", nil, auraFrame, "CooldownFrameTemplate")
    cooldown:SetAllPoints(icon)
    cooldown:SetDrawBling(false)
    cooldown:SetReverse(true)
    if cooldown.SetCountdownFont then
        cooldown:SetCountdownFont("NumberFontNormalSmall")
    end
    auraFrame:SetDurationCooldown(cooldown)
    auraFrame.suiCooldown = cooldown

    -- The swipe is a child frame; borders and count live one level above it.
    local overlay = CreateFrame("Frame", nil, auraFrame)
    overlay:SetAllPoints(auraFrame)
    overlay:SetFrameLevel(cooldown:GetFrameLevel() + 1)

    local typeBorder = RF.StyleAura(auraFrame, icon, overlay, isDebuff)
    if typeBorder then
        if auraFrame.SetAuraBorder then
            auraFrame:SetAuraBorder(typeBorder, DISPEL_BORDER)
        else
            typeBorder:SetVertexColor(0.8, 0, 0, 1)
        end
    end

    local count = overlay:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    count:SetFont(STANDARD_TEXT_FONT, max(floor(base / 2.6), 8), "OUTLINE")
    count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
    auraFrame:SetApplicationCount(count)
    auraFrame.suiCount = count

    local list = container.suiButtons
    list[#list + 1] = auraFrame
    applyButton(auraFrame, container)
end

-- Containers ---------------------------------------------------------------------------------
local function newRow(frame, level)
    local container = newContainer(frame, level)
    container.suiButtons = {}
    return container
end

-- Built once per frame; the initializers are the only per-frame closures.
local function build(frame)
    local data = {}
    local buffs, debuffs, defensives = newRow(frame, 4), newRow(frame, 6), newRow(frame, 8)
    data.buffs, data.debuffs, data.defensives = buffs, debuffs, defensives

    buffs:AddAuraGroup("Buffs", buffFilter, {
        maxFrameCount = MAX_BUFFS, candidateFilters = FRIENDLY, layout = LAYOUT,
        initializeFrame = function(auraFrame)
            styleButton(auraFrame, buffs, "buffs", BASE, false)
        end,
    })
    debuffs:AddAuraGroup("DebuffsLead", debuffFilter, {
        maxFrameCount = MAX_LEAD, candidateFilters = LEAD_ONLY, layout = LAYOUT,
        initializeFrame = function(auraFrame)
            styleButton(auraFrame, debuffs, "debuffs", LEAD_BASE, true)
        end,
    })
    debuffs:AddAuraGroup("Debuffs", debuffFilter, {
        maxFrameCount = MAX_DEBUFFS, candidateFilters = NOT_LEAD, layout = LAYOUT,
        initializeFrame = function(auraFrame)
            styleButton(auraFrame, debuffs, "debuffs", BASE, true)
        end,
    })
    local initDefensive = function(auraFrame)
        styleButton(auraFrame, defensives, "defensives", BASE, false)
    end
    defensives:AddAuraGroup("Defensives", "HELPFUL|BIG_DEFENSIVE", {
        maxFrameCount = MAX_DEFENSIVES, candidateFilters = FRIENDLY, layout = LAYOUT, initializeFrame = initDefensive,
    })
    defensives:AddAuraGroup("DefensivesExternal", "HELPFUL|EXTERNAL_DEFENSIVE|!BIG_DEFENSIVE", {
        maxFrameCount = 0, candidateFilters = FRIENDLY, layout = LAYOUT, initializeFrame = initDefensive,
    })

    tracked[frame] = data
    return data
end

local function refreshButtons(container)
    local list = container.suiButtons
    for i = 1, #list do
        applyButton(list[i], container)
    end
end

local function setScale(container, px)
    local scale = px / BASE
    if container.suiScale ~= scale then
        container.suiScale = scale
        container:SetScale(scale)
        refreshButtons(container)
    end
    return scale
end

local function percent(height, value)
    return max(floor(height * value / 100 + 0.5), 6)
end

local function placeRow(frame, container, settings, scale)
    local point = settings.point
    local reference, relative, dx, dy = RF.AuraAnchor(frame, point)
    local horizontal, hs, vs = RF.AuraGrowth(point, settings.grow)
    local directions = AnchorUtil.FlowDirection
    local primary, secondary
    if horizontal then
        primary, secondary = hs > 0 and directions.Right or directions.Left, vs > 0 and directions.Up or directions.Down
    else
        primary, secondary = vs > 0 and directions.Up or directions.Down, hs > 0 and directions.Right or directions.Left
    end
    container:ClearAllPoints()
    container:SetPoint(point, reference, relative, (dx + settings.x) / scale, (dy + settings.y) / scale)
    container:SetFlowLayoutAnchorPoint(point)
    container:SetFlowLayoutGrowthDirection(primary, secondary)
end

local function apply(frame, data, height)
    local db = SUI.db.profile.raidframes.auras
    local b, d, def = db.buffs, db.debuffs, db.defensives

    local buffs, debuffs, defensives = data.buffs, data.debuffs, data.defensives
    buffs:SetAuraGroupFilterString("Buffs", buffFilter)
    buffs:SetAuraGroupMaxFrameCount("Buffs", buffCount)
    buffs:SetFlowLayoutMaximumLineSize(min(max(b.perrow, 1), MAX_BUFFS) * (BASE + GAP))

    debuffs:SetAuraGroupFilterString("DebuffsLead", debuffFilter)
    debuffs:SetAuraGroupFilterString("Debuffs", debuffFilter)
    debuffs:SetAuraGroupMaxFrameCount("DebuffsLead", leadCount)
    debuffs:SetAuraGroupMaxFrameCount("Debuffs", debuffCount)
    -- Measured in lead icons, the wider ones.
    debuffs:SetFlowLayoutMaximumLineSize(max(d.perrow, 1) * (LEAD_BASE + GAP))

    defensives:SetAuraGroupMaxFrameCount("Defensives", bigCount)
    defensives:SetAuraGroupMaxFrameCount("DefensivesExternal", externalCount)
    defensives:SetFlowLayoutMaximumLineSize(MAX_DEFENSIVES * (BASE + GAP))

    placeRow(frame, buffs, b, setScale(buffs, percent(height, b.size)))
    placeRow(frame, debuffs, d, setScale(debuffs, percent(height, d.size)))

    local scale = setScale(defensives, percent(height, def.size))
    local point = DEFENSIVE_POINTS[def.point] and def.point or "CENTER"
    defensives:ClearAllPoints()
    defensives:SetPoint(point, frame, point, def.x / scale, def.y / scale)
    defensives:SetFlowLayoutAnchorPoint(point)
    defensives:SetFlowLayoutGrowthDirection(
        point == "RIGHT" and AnchorUtil.FlowDirection.Left or AnchorUtil.FlowDirection.Right,
        AnchorUtil.FlowDirection.Down)
end

local function hide(data)
    if data then
        data.unit = nil
        setContainerUnit(data.buffs, nil)
        setContainerUnit(data.debuffs, nil)
        setContainerUnit(data.defensives, nil)
    end
end

-- Runs when the client points a frame at a unit, on roster changes and once a
-- second for phase/visibility; only does work when something moved.
function Auras:Update(frame)
    local data = tracked[frame]
    local unit = frame.displayedUnit or frame.unit
    -- Target-of frames get no rows.
    if not unit or strfind(unit, "target", 1, true) then
        hide(data)
        return
    end
    if not data then
        data = build(frame)
    end

    local height = frame:GetHeight()
    if not height or not CanAccess(height) or height < 1 then
        height = FALLBACK_HEIGHT
    end
    local powerBar = frame.powerBar
    local power = powerBar ~= nil and powerBar:IsShown()
    local phased = UnitPhaseReason ~= nil and UnitPhaseReason(unit) ~= nil
    local unseen = UnitIsVisible ~= nil and not UnitIsVisible(unit)

    if data.unit == unit and data.height == height and data.power == power and data.phased == phased
        and data.unseen == unseen and data.revision == revision then
        return
    end
    data.unit, data.height, data.power, data.phased, data.unseen, data.revision =
        unit, height, power, phased, unseen, revision

    apply(frame, data, height)

    if phased then
        hide(data)
        data.unit = unit
        return
    end
    -- Out of sight, own/important buffs and defensives have no usable data;
    -- an unassistable unit (duel) breaks the defensive row.
    setContainerUnit(data.buffs, (unseen and buffsNeedVisible) and nil or unit)
    setContainerUnit(data.debuffs, unit)
    local canAssist = UnitCanAssist == nil or UnitCanAssist("player", unit)
    setContainerUnit(data.defensives, (unseen or not canAssist) and nil or unit)
end

RF.On("CompactUnitFrame_SetUnit", Auras, Auras.Update)

local function updateAll()
    RF.ForEachFrame(Auras.Update, Auras)
end

local function tick()
    if IsInGroup() then
        for frame in pairs(tracked) do
            Auras:Update(frame)
        end
    end
end

function Auras:OnLoad()
    resolveBorderStyle()
end

function Auras:Refresh()
    resolve(self.db)
    revision = revision + 1
    for _, data in pairs(tracked) do
        refreshButtons(data.buffs)
        refreshButtons(data.debuffs)
        refreshButtons(data.defensives)
    end
    updateAll()
end

function Auras:OnEnable()
    requestBlizzardAuras(false)
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnWorld")
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "Soon")
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "Soon")
    self:NewTicker(1, tick)
    self:Refresh()
end

-- Edit Mode writes the same CVars from its raid frame checkboxes.
function Auras:OnWorld()
    requestBlizzardAuras(false)
    self:Soon()
end

function Auras:Soon()
    self:After(0.1, updateAll)
end

function Auras:OnRefresh(key)
    if not key or strfind(key, "^auras%.") then
        self:Refresh()
    end
end

function Auras:OnDisable()
    for _, data in pairs(tracked) do
        hide(data)
    end
    requestBlizzardAuras(true)
end
