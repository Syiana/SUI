--[[ SUI 2.0 - Features/UnitFrames/Auras.lua
    Target and focus auras (unitframes.buffs / unitframes.debuffs) in the
    SUI 1.x look. Retail 12.1 draws Blizzard's target auras with private
    buttons that addons cannot style, so, like 1.x, SUI turns them off via
    the container's public setters and shows the auras in its own
    CustomAuraContainerTemplate containers: debuffs split by dispel type
    (so the border colour never reads a secret), plain buffs and purgeable
    (Magic) buffs. Buttons are built and styled once in initializeFrame.
    The classic clients still use named aura buttons, which are filtered,
    styled, resized and re-anchored after TargetFrame:UpdateAuras.
]]

local _, ns = ...
local SUI = ns.SUI
local UF = ns.UnitFrames

local _G, max, min, floor, wipe = _G, math.max, math.min, math.floor, wipe
local UnitIsUnit, UnitIsPlayer, UnitExists = UnitIsUnit, UnitIsPlayer, UnitExists
local CreateFrame, STANDARD_TEXT_FONT = CreateFrame, STANDARD_TEXT_FONT

local SPACING = 3

-- Countdown text shrinks with the icon so "30m" stays inside it. The cooldown
-- frame only honours a named font object, and resizing the object updates
-- every icon that uses it.
local countdownFonts = {}
local function countdownFont(kind, settings)
    local name = kind == "debuffs" and "SUIAuraDebuffCountdownFont" or "SUIAuraBuffCountdownFont"
    local font = countdownFonts[name]
    if not font then
        font = CreateFont(name)
        countdownFonts[name] = font
    end
    font:SetFont(STANDARD_TEXT_FONT, max(min(settings.targettextsize, floor(settings.size * 0.5)), 6), "OUTLINE")
    return font, name
end

-- Retail ---------------------------------------------------------------------------------------
local Retail = SUI:NewFeature("UnitFrames.Auras", {
    category = "unitframes",
    clients = { Mainline = true },
})

local LAYOUT = { elementSpacing = SPACING, lineSpacing = SPACING }
local ALL_DISPELS = { Magic = true, Curse = true, Disease = true, Poison = true }
local MAGIC = { Magic = true }

-- Candidate filters are built once; "own" adds isFromPlayerOrPlayerPet.
local function debuffGroup(key, kind, include, exclude)
    return {
        key = key,
        kind = kind,
        all = { includeDispelTypes = include, excludeDispelTypes = exclude },
        own = { includeDispelTypes = include, excludeDispelTypes = exclude, isFromPlayerOrPlayerPet = true },
    }
end
local DEBUFF_GROUPS = {
    debuffGroup("DebuffsNone", "none", nil, ALL_DISPELS),
    debuffGroup("DebuffsMagic", "Magic", MAGIC, nil),
    debuffGroup("DebuffsCurse", "Curse", { Curse = true }, nil),
    debuffGroup("DebuffsDisease", "Disease", { Disease = true }, nil),
    debuffGroup("DebuffsPoison", "Poison", { Poison = true }, nil),
}

local sets = {}    -- unit frame -> { debuffs, buffs, stealable, unit, own }
local buttons = {} -- aura button -> "buffs" | "debuffs"
local ORDER = { "debuffs", "buffs", "stealable" }

local function applyButton(button)
    local settings = Retail.db[buttons[button]]
    button:SetSize(settings.size, settings.size)
    button.Count:SetFont(STANDARD_TEXT_FONT, settings.targettextsize, "OUTLINE")
    countdownFont(buttons[button], settings)
end

local function initButton(button, kind, r, g, b)
    buttons[button] = kind
    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetAllPoints(button)
    button:SetIcon(icon)

    local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
    cooldown:SetAllPoints(icon)
    cooldown:SetDrawBling(false)
    cooldown:SetReverse(true)
    button:SetDurationCooldown(cooldown)
    local font, fontName = countdownFont(kind, Retail.db[kind])
    if cooldown.SetCountdownFont then
        cooldown:SetCountdownFont(fontName)
    end
    local countdown = cooldown.GetCountdownFontString and cooldown:GetCountdownFontString()
    if countdown then
        if not cooldown.SetCountdownFont then
            countdown:SetFontObject(font)
        end
        countdown:ClearAllPoints()
        countdown:SetPoint("LEFT", icon, "LEFT", -4, 0)
        countdown:SetPoint("RIGHT", icon, "RIGHT", 4, 0)
        countdown:SetJustifyH("CENTER")
        countdown:SetWordWrap(false)
    end

    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints(button)
    overlay:SetFrameLevel(cooldown:GetFrameLevel() + 1)

    local count = overlay:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, 0)
    button:SetApplicationCount(count)
    button.Count = count

    UF.StyleAura(button, icon, overlay)
    UF.ColorAura(button, r, g, b)
    applyButton(button)
end

local function newContainer(parent, unit)
    local container = CreateFrame("AuraContainer", nil, parent, "CustomAuraContainerTemplate")
    container:SetFrameLevel(max(parent:GetFrameLevel() + 2, 0))
    container:SetSize(1, 1)
    container:SetFlowLayoutPadding(0, 0, 0, 10)
    container:SetUnit(unit)
    container:SetEnabled(true)
    return container
end

local function createSet(frame, unit)
    local parent = frame.TargetFrameContent and frame.TargetFrameContent.TargetFrameContentContextual or frame
    local set = { unit = unit, debuffs = newContainer(parent, unit), buffs = newContainer(parent, unit), stealable = newContainer(parent, unit) }
    sets[frame] = set

    set.buffs:AddAuraGroup("Buffs", "HELPFUL", {
        maxFrameCount = 32,
        candidateFilters = { excludeDispelTypes = MAGIC },
        initializeFrame = function(button)
            initButton(button, "buffs")
        end,
        layout = LAYOUT,
    })
    -- Split by dispel type rather than isStealable, which is only set for
    -- classes with an offensive dispel. Purgeable buffs get a white border.
    set.stealable:AddAuraGroup("BuffsStealable", "HELPFUL", {
        maxFrameCount = 32,
        candidateFilters = { includeDispelTypes = MAGIC },
        initializeFrame = function(button)
            initButton(button, "buffs", 1, 1, 1)
        end,
        layout = LAYOUT,
    })
    for i = 1, #DEBUFF_GROUPS do
        local group = DEBUFF_GROUPS[i]
        local kind = group.kind
        set.debuffs:AddAuraGroup(group.key, "HARMFUL|PLAYER", {
            maxFrameCount = 16,
            candidateFilters = group.own,
            initializeFrame = function(button)
                initButton(button, "debuffs", UF.DEBUFF_R[kind], UF.DEBUFF_G[kind], UF.DEBUFF_B[kind])
            end,
            layout = LAYOUT,
        })
    end
    set.own = true
    return set
end

local function isEnabled(which, db)
    if which == "debuffs" then
        return db.debuffs.mode ~= "hide"
    end
    local mode = db.buffs.mode
    if which == "stealable" then
        return mode == "all" or mode == "purgeable"
    end
    return mode == "all" or mode == "normal"
end

-- Stacks the enabled containers below (or above) the frame art, like 1.x.
local function reflow(frame, set)
    local db = Retail.db
    local mirror = frame.buffsOnTop == true
    local point, relativePoint, frameY, chainY = "TOPLEFT", "BOTTOMLEFT", 4, 4
    local vertical = AnchorUtil.FlowDirection.Down
    if mirror then
        point, relativePoint, frameY, chainY = "BOTTOMLEFT", "TOPLEFT", -6, 0
        vertical = AnchorUtil.FlowDirection.Up
    end
    local anchor = frame.TargetFrameContainer and frame.TargetFrameContainer.FrameTexture or frame
    local previous, previousX

    for i = 1, #ORDER do
        local which = ORDER[i]
        local container = set[which]
        local settings = which == "debuffs" and db.debuffs or db.buffs
        local x, y = settings.targetx, settings.targety
        local enabled = isEnabled(which, db)
        container:ClearAllPoints()
        if enabled and previous then
            container:SetPoint(point, previous, relativePoint, x - previousX, chainY + y)
        else
            container:SetPoint(point, anchor, relativePoint, 5 + x, frameY + y)
        end
        if enabled then
            previous, previousX = container, x
        end
        container:SetFlowLayoutAnchorPoint(point)
        container:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, vertical)
        local perRow = max(settings.perrow, 1)
        container:SetFlowLayoutMaximumLineSize(perRow * settings.size + (perRow - 1) * SPACING)
    end
    set.last = previous or set.buffs

    -- Cast bar below the auras unless SUI's cast bar settings put it on top.
    local spellbar = frame.spellbar
    local castbars = SUI.db.profile.castbars
    local onTop = castbars and ((frame == _G.TargetFrame and castbars.targetOnTop) or (frame == _G.FocusFrame and castbars.focusOnTop))
    if spellbar and not mirror and not onTop and not spellbar:IsForbidden() then
        spellbar:ClearAllPoints()
        spellbar:SetPoint("TOPLEFT", set.last, "BOTTOMLEFT", 18, -2)
    end
end

local function updateFilters(set, db)
    local own = db.debuffs.mode == "own"
    if set.own == own then
        return
    end
    set.own = own
    local filter = own and "HARMFUL|PLAYER" or "HARMFUL"
    for i = 1, #DEBUFF_GROUPS do
        local group = DEBUFF_GROUPS[i]
        set.debuffs:SetAuraGroupFilterString(group.key, filter)
        set.debuffs:SetAuraGroupCandidateFilters(group.key, own and group.own or group.all)
    end
end

local function update(frame)
    local set = sets[frame]
    if not set then
        return
    end
    local db = Retail.db
    updateFilters(set, db)
    for i = 1, #ORDER do
        local container = set[ORDER[i]]
        local enabled = isEnabled(ORDER[i], db)
        container:SetEnabled(enabled)
        container:SetShown(enabled)
        if enabled then
            container:SetUnit(set.unit)
            container:UpdateAllAuras()
        end
    end
    reflow(frame, set)
end

-- Blizzard's own target auras stay empty while SUI draws them.
local function silenceBlizzard(frame)
    local container = frame.GetAuraContainer and frame:GetAuraContainer()
    if container and container.SetMaxBuffs then
        container:SetMaxBuffs(0)
        container:SetMaxDebuffs(0)
    end
    local set = sets[frame]
    if set then
        reflow(frame, set)
    end
end

-- 1.x moved target-of-target out of the way of the aura rows.
local function placeTargetOfTarget()
    for _, name in next, { "TargetFrame", "FocusFrame" } do
        local frame, tot = _G[name], _G[name .. "ToT"]
        if frame and tot and not tot:IsForbidden() then
            tot:ClearAllPoints()
            tot:SetPoint("RIGHT", frame, "RIGHT", 45, -55)
        end
    end
end

function Retail:OnLoad()
    if not C_UnitAuras or not AnchorUtil or not AnchorUtil.FlowDirection then
        return
    end
    for unit, name in next, { target = "TargetFrame", focus = "FocusFrame" } do
        local frame = _G[name]
        if frame and frame.GetAuraContainer then
            createSet(frame, unit)
            if frame.ConfigureAuraContainer then
                self:Hook(frame, "ConfigureAuraContainer", silenceBlizzard)
            end
        end
    end
end

function Retail:Target()
    update(_G.TargetFrame)
end

function Retail:Focus()
    update(_G.FocusFrame)
end

function Retail:Apply()
    for frame in next, sets do
        silenceBlizzard(frame)
        update(frame)
    end
    for button in next, buttons do
        applyButton(button)
    end
end

function Retail:OnEnable()
    self:RegisterEvent("PLAYER_TARGET_CHANGED", "Target")
    self:RegisterEvent("PLAYER_FOCUS_CHANGED", "Focus")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function()
        SUI:RunAfterCombat(placeTargetOfTarget)
        Retail:Apply()
    end)
    SUI:RunAfterCombat(placeTargetOfTarget)
    self:Apply()
end

Retail.OnRefresh = Retail.Apply


-- Classic --------------------------------------------------------------------------------------
local Classic = SUI:NewFeature("UnitFrames.AurasClassic", {
    category = "unitframes",
    clients = { Classic = true },
})

local ForEachAura = SUI.Compat.ForEachAura
local MAX_BUTTONS = 40
local shown = {}   -- reused list of buttons that pass the filter
local passes = {}  -- aura display index -> passes the SUI filter
local scanFrame, scanCount, wantMagic

local function fill(value)
    for i = 1, MAX_BUTTONS do
        passes[i] = value
    end
end

-- Buffs map 1:1 to HELPFUL auras.
local function scanBuff(aura)
    scanCount = scanCount + 1
    passes[scanCount] = (aura.dispelName == "Magic") == wantMagic
end

-- Blizzard skips some debuffs, so replay its filter to keep the indices aligned.
local function scanDebuff(aura)
    local caster = aura.sourceUnit
    local fromPlayer = aura.isFromPlayerOrPlayerPet
    if fromPlayer == nil then
        fromPlayer = caster ~= nil and UnitIsPlayer(caster)
    end
    if scanFrame:ShouldShowDebuffs(scanFrame.unit, caster, aura.nameplateShowAll, fromPlayer) then
        scanCount = scanCount + 1
        passes[scanCount] = caster ~= nil and (UnitIsUnit(caster, "player") or UnitIsUnit(caster, "pet") or UnitIsUnit(caster, "vehicle"))
    end
end

-- 1.x look on a named classic aura button: styled once, recoloured per update.
local function styleClassicButton(button, isDebuff, textSize)
    local name = button:GetName()
    if not name then
        return
    end
    if not button.suiOverlay then
        local overlay = CreateFrame("Frame", nil, button)
        overlay:SetAllPoints(button)
        local cooldown = _G[name .. "Cooldown"]
        overlay:SetFrameLevel((cooldown or button):GetFrameLevel() + 1)
        button.suiOverlay = overlay
        UF.StyleAura(button, _G[name .. "Icon"], overlay, isDebuff and _G[name .. "Border"] or nil)
    end
    if isDebuff then
        local border = _G[name .. "Border"]
        if border then
            UF.ColorAura(button, border:GetVertexColor())
        end
    else
        local stealable = _G[name .. "Stealable"]
        if stealable and stealable:IsShown() then
            UF.ColorAura(button, 1, 1, 1)
        else
            UF.ColorAura(button)
        end
    end
    local count = _G[name .. "Count"]
    if count and button.suiTextSize ~= textSize then
        count:SetFont(STANDARD_TEXT_FONT, textSize, "OUTLINE")
        count:ClearAllPoints()
        count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, 0)
        button.suiTextSize = textSize
    end
end

local function styleGroup(frame, prefix, settings, mirror)
    local size, perRow = settings.size, max(settings.perrow, 1)
    local isDebuff = prefix:find("Debuff", 1, true) ~= nil
    local start = _G[prefix .. 1]
    if not start then
        return
    end
    -- Blizzard anchors the first button of a group to the frame or the other group.
    local point, relativeTo, relativePoint, x, y = start:GetPoint(1)
    wipe(shown)
    for i = 1, MAX_BUTTONS do
        local button = _G[prefix .. i]
        if not button or not button:IsShown() then
            break
        end
        if passes[i] then
            shown[#shown + 1] = button
        else
            button:Hide()
        end
    end
    local n = #shown
    if n == 0 then
        return
    end

    local first = shown[1]
    local vertical, opposite = mirror and "BOTTOM" or "TOP", mirror and "TOP" or "BOTTOM"
    local gap = mirror and SPACING or -SPACING
    local textSize = settings.targettextsize
    local rowStart = first

    for i = 1, n do
        local button = shown[i]
        button:SetSize(size, size)
        if i == 1 then
            if point then
                button:ClearAllPoints()
                button:SetPoint(point, relativeTo, relativePoint, (x or 0) + settings.targetx, (y or 0) + settings.targety)
            end
        else
            button:ClearAllPoints()
            if (i - 1) % perRow == 0 then
                button:SetPoint(vertical .. "LEFT", rowStart, opposite .. "LEFT", 0, gap)
                rowStart = button
            else
                button:SetPoint("LEFT", shown[i - 1], "RIGHT", SPACING, 0)
            end
        end
        styleClassicButton(button, isDebuff, textSize)
        local name = isDebuff and button:GetName()
        local border = name and _G[name .. "Border"]
        if border then
            border:SetSize(size + 2, size + 2)
        end
    end

    -- Blizzard anchors the other aura group and the cast bar to these holders.
    local holder = isDebuff and frame.debuffs or frame.buffs
    if holder then
        holder:ClearAllPoints()
        holder:SetPoint(vertical .. "LEFT", first, vertical .. "LEFT", 0, 0)
        holder:SetPoint(opposite .. "LEFT", rowStart, opposite .. "LEFT", 0, gap)
    end
end

local function updateAuras(frame)
    local unit = frame.unit
    if not unit or not UnitExists(unit) then
        return
    end
    local db = Classic.db
    local name = frame:GetName()
    local mirror = frame.buffsOnTop == true

    local mode = db.buffs.mode
    scanFrame, scanCount = frame, 0
    if mode == "purgeable" or mode == "normal" then
        wantMagic = mode == "purgeable"
        ForEachAura(unit, "HELPFUL", scanBuff)
    else
        fill(mode ~= "hide")
    end
    styleGroup(frame, name .. "Buff", db.buffs, mirror)

    mode = db.debuffs.mode
    scanCount = 0
    if mode == "own" and frame.ShouldShowDebuffs then
        ForEachAura(unit, "HARMFUL|INCLUDE_NAME_PLATE_ONLY", scanDebuff)
    else
        fill(mode ~= "hide")
    end
    styleGroup(frame, name .. "Debuff", db.debuffs, mirror)
end

function Classic:OnLoad()
    for _, name in next, { "TargetFrame", "FocusFrame" } do
        local frame = _G[name]
        if frame and frame.UpdateAuras then
            self:Hook(frame, "UpdateAuras", updateAuras)
        end
    end
end

-- Re-running Blizzard's aura update is only done out of combat.
local function refresh()
    for _, name in next, { "TargetFrame", "FocusFrame" } do
        local frame = _G[name]
        if frame and frame.UpdateAuras and frame:IsShown() then
            frame:UpdateAuras()
        end
    end
end

function Classic:OnEnable()
    SUI:RunAfterCombat(refresh)
end

function Classic:OnRefresh()
    SUI:RunAfterCombat(refresh)
end
