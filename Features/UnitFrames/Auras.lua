--[[ SUI 2.0 - Features/UnitFrames/Auras.lua
    Target and focus aura layout (unitframes.buffs / unitframes.debuffs).
    Retail 12.1 draws these auras in a protected aura container; SUI only
    feeds it filter strings, sizes and the row width through its public
    setters after Blizzard configured it. The classic clients still use
    named aura buttons, which are filtered, resized and re-anchored after
    TargetFrame:UpdateAuras.
]]

local _, ns = ...
local SUI = ns.SUI

local _G, max, wipe = _G, math.max, wipe
local UnitIsUnit, UnitIsPlayer, UnitExists = UnitIsUnit, UnitIsPlayer, UnitExists

local SPACING = 3

-- Retail ---------------------------------------------------------------------------------------
local Retail = SUI:NewFeature("UnitFrames.Auras", {
    category = "unitframes",
    clients = { Mainline = true },
})

local BUFF_FILTERS = {
    all = "HELPFUL",
    normal = "HELPFUL|!DISPELLABLE",
    purgeable = "HELPFUL|DISPELLABLE",
}
local DEBUFF_FILTERS = {
    all = "HARMFUL|INCLUDE_NAME_PLATE_ONLY",
    own = "HARMFUL|PLAYER|INCLUDE_NAME_PLATE_ONLY",
}

local function configure(frame)
    local container = frame.GetAuraContainer and frame:GetAuraContainer()
    if not container or not container.SetSmallAuraSize then
        return
    end
    local db = Retail.db
    local defaults = TargetFrameAuraContainerDefaults
    local buffs, debuffs = db.buffs, db.debuffs

    local perRow = max(buffs.perrow, 1)
    container:SetMaxBuffs(buffs.mode == "hide" and 0 or (frame.maxBuffs or defaults.MaxBuffs))
    container:SetMaxDebuffs(debuffs.mode == "hide" and 0 or (frame.maxDebuffs or defaults.MaxDebuffs))
    container:SetBuffFilterString(BUFF_FILTERS[buffs.mode] or defaults.BuffFilterString)
    container:SetDebuffFilterString(DEBUFF_FILTERS[debuffs.mode] or defaults.DebuffFilterString)
    -- Blizzard sizes auras by caster, not by type: other auras small, own auras large.
    container:SetSmallAuraSize(buffs.size)
    container:SetLargeAuraSize(max(buffs.size, debuffs.size))
    container:SetFlowLayoutMaximumLineSize(perRow * buffs.size + (perRow - 1) * SPACING)
end

function Retail:OnLoad()
    for _, name in next, { "TargetFrame", "FocusFrame" } do
        local frame = _G[name]
        if frame and frame.ConfigureAuraContainer and TargetFrameAuraContainerDefaults then
            self:Hook(frame, "ConfigureAuraContainer", configure)
        end
    end
end

function Retail:Apply()
    if not TargetFrameAuraContainerDefaults then
        return
    end
    for _, name in next, { "TargetFrame", "FocusFrame" } do
        if _G[name] then
            configure(_G[name])
        end
    end
end

Retail.OnEnable = Retail.Apply
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

local function styleGroup(frame, prefix, settings, mirror)
    local size, perRow = settings.size, max(settings.perrow, 1)
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
        local name = button:GetName()
        local count = name and _G[name .. "Count"]
        if count and button.suiTextSize ~= textSize then
            local font, _, flags = count:GetFont()
            if font then
                count:SetFont(font, textSize, flags)
                button.suiTextSize = textSize
            end
        end
        local border = name and _G[name .. "Border"]
        if border then
            border:SetSize(size + 2, size + 2)
        end
    end

    -- Blizzard anchors the other aura group and the cast bar to these holders.
    local holder = prefix:find("Debuff", 1, true) and frame.debuffs or frame.buffs
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
