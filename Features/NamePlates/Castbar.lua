--[[
    SUI 2.0 - Features/NamePlates/Castbar.lua

    Nameplate castbars: icon left of the bar with a themed border, cast time
    below the icon and colours for the interrupt state (own interrupt on
    cooldown, cast cannot be interrupted). Each castbar is set up once; the
    work runs on its cast events, and the cast time only while it is shown.
]]

local _, ns = ...
local SUI = ns.SUI
local NP = ns.NamePlates

local next, max = next, math.max
local UnitCastingInfo, UnitChannelInfo = UnitCastingInfo, UnitChannelInfo
local CanAccess, IsSecret = SUI.Compat.CanAccess, SUI.Compat.IsSecret

local F = SUI:NewFeature("NamePlates.Castbar", {
    category = "nameplates",
    toggle = NP.isCustom,
    conflicts = NP.conflicts,
    reload = true, -- icon anchors are only restored by Blizzard on a new layout
})

-- Interrupts per class (retail and classic ids; the first known one is used).
local KICKS = {
    WARRIOR = { 6552, 72 },
    ROGUE = { 1766 },
    MAGE = { 2139 },
    SHAMAN = { 57994, 8042 },
    PRIEST = { 15487 },
    HUNTER = { 147362, 187707, 34490 },
    WARLOCK = { 119910, 19244, 89766 },
    PALADIN = { 96231, 31935 },
    DRUID = { 106839, 78675, 16979 },
    DEATHKNIGHT = { 47528 },
    MONK = { 116705 },
    DEMONHUNTER = { 183752 },
    EVOKER = { 351338 },
}

local ANCHOR_EVENTS = {
    UNIT_SPELLCAST_START = true,
    UNIT_SPELLCAST_CHANNEL_START = true,
    UNIT_SPELLCAST_EMPOWER_START = true,
}
local COLOR_EVENTS = {
    UNIT_SPELLCAST_START = true,
    UNIT_SPELLCAST_CHANNEL_START = true,
    UNIT_SPELLCAST_EMPOWER_START = true,
    UNIT_SPELLCAST_INTERRUPTIBLE = true,
    UNIT_SPELLCAST_NOT_INTERRUPTIBLE = true,
}

local barState, timers, elapsedBy, active = {}, {}, {}, {}
local showTime, useColors, kickSpell = false, false, nil
local cdR, cdG, cdB, shR, shG, shB = 0.85, 0.15, 0.15, 0.6, 0.6, 0.6
-- Blizzard's own fill colours: retail fills are coloured atlases (white tint).
local castR, castG, castB, chanR, chanG, chanB = 1, 1, 1, 1, 1, 1
local EvalBool, kickReady, castTime, isKnown

local function exists(v)
    return IsSecret(v) or v ~= nil
end

-- value may be a Midnight secret boolean; the curve helper resolves it without reading it.
local function pick(value, a, b)
    if IsSecret(value) then
        if EvalBool then
            return EvalBool(value, a, b)
        end
        return b
    end
    if value then
        return a
    end
    return b
end

local function readyByDuration(spell)
    local duration = C_Spell.GetSpellCooldownDuration(spell, true)
    if duration then
        return duration:IsZero()
    end
    return true
end

local function readyByNumbers(spell)
    local _, duration = GetSpellCooldown(spell)
    return not CanAccess(duration) or not duration or duration <= 1.5
end

local function readyByInfo(spell)
    local info = C_Spell.GetSpellCooldown(spell)
    return not info or not CanAccess(info.duration) or info.duration <= 1.5
end

-- Returns casting, channel, notInterruptible (the last may be secret).
local function castInfo(unit)
    local name, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit)
    if exists(name) then
        return true, false, notInterruptible
    end
    name, _, _, _, _, _, notInterruptible = UnitChannelInfo(unit)
    return exists(name), true, notInterruptible
end

local function colorCast(bar, st, channel, notInterruptible)
    active[bar] = st
    local r, g, b = castR, castG, castB
    if channel then
        r, g, b = chanR, chanG, chanB
    end
    if kickSpell then
        local ready = kickReady(kickSpell)
        r, g, b = pick(ready, r, cdR), pick(ready, g, cdG), pick(ready, b, cdB)
    end
    r, g, b = pick(notInterruptible, shR, r), pick(notInterruptible, shG, g), pick(notInterruptible, shB, b)
    bar:SetStatusBarColor(r, g, b)
end

local function anchorIcon(bar)
    local icon = bar.Icon
    if icon then
        icon:ClearAllPoints()
        icon:SetPoint("CENTER", bar, "LEFT", -10, 0)
    end
    if bar.BorderShield then
        bar.BorderShield:ClearAllPoints()
        bar.BorderShield:SetPoint("CENTER", bar, "LEFT", -10, 0)
    end
end

local function timeByDuration(_, st, timer)
    local duration = UnitCastingDuration(st.unit) or UnitChannelDuration(st.unit)
    if duration then
        timer:SetFormattedText("%.1f", duration:GetRemainingDuration())
    else
        timer:SetText("")
    end
end

local function timeByValue(bar, _, timer)
    local value, maxValue = bar.value, bar.maxValue
    if not (CanAccess(value) and CanAccess(maxValue) and value and maxValue) then
        timer:SetText("")
    elseif bar.casting then
        timer:SetFormattedText("%.1f", max(maxValue - value, 0))
    elseif bar.channeling then
        timer:SetFormattedText("%.1f", max(value, 0))
    else
        timer:SetText("")
    end
end

local function onCastEvent(bar, event)
    if not F.enabled then
        return
    end
    local st = barState[bar]
    if not st.unit then
        return
    end
    if ANCHOR_EVENTS[event] then
        anchorIcon(bar)
    end
    if COLOR_EVENTS[event] then
        local casting, channel, notInterruptible = castInfo(st.unit)
        if casting then
            -- 1.x: the icon gives way to Blizzard's shield on uninterruptible casts.
            NP.SetIconHidden(bar.Icon, notInterruptible)
            if useColors then
                colorCast(bar, st, channel, notInterruptible)
            end
        end
    end
end

local function onCastUpdate(bar, elapsed)
    if not showTime then
        return
    end
    local total = (elapsedBy[bar] or 0) + elapsed
    if total < 0.1 then
        elapsedBy[bar] = total
        return
    end
    elapsedBy[bar] = 0
    local st = barState[bar]
    if st.unit then
        castTime(bar, st, timers[bar])
    end
end

local function setup(st)
    local bar = st.castBar
    if not bar or barState[bar] then
        return
    end
    barState[bar] = st
    bar:HookScript("OnEvent", onCastEvent)
    bar:HookScript("OnUpdate", onCastUpdate)
    if bar.Text then
        bar.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    end
    local icon = bar.Icon
    if icon then
        NP.SkinIcon(icon, bar)
    end
    local timer = bar:CreateFontString(nil, "OVERLAY")
    timer:SetFont(STANDARD_TEXT_FONT, 8, "THINOUTLINE")
    if icon then
        timer:SetPoint("CENTER", icon, "BOTTOM", 0, -5)
    else
        timer:SetPoint("RIGHT", bar, "LEFT", -2, 0)
    end
    timers[bar] = timer
    anchorIcon(bar)
end

function F:OnLoad()
    EvalBool = C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean
    if C_Spell and C_Spell.GetSpellCooldownDuration then
        kickReady = readyByDuration
    elseif GetSpellCooldown then
        kickReady = readyByNumbers
    else
        kickReady = readyByInfo
    end
    castTime = (UnitCastingDuration and UnitChannelDuration) and timeByDuration or timeByValue
    if C_SpellBook and C_SpellBook.IsSpellKnownOrInSpellBook then
        local known, pet = C_SpellBook.IsSpellKnownOrInSpellBook, Enum.SpellBookSpellBank.Pet
        isKnown = function(id)
            return known(id) or known(id, pet)
        end
    else
        isKnown = function(id)
            return IsSpellKnown(id) or IsSpellKnown(id, true)
        end
    end
    if not SUI.IsRetail then
        castR, castG, castB, chanR, chanG, chanB = 1, 0.7, 0, 0, 1, 0
    end
end

function F:UpdateKick()
    kickSpell = nil
    local _, class = UnitClass("player")
    local spells = KICKS[class]
    if spells then
        for i = 1, #spells do
            if isKnown(spells[i]) then
                kickSpell = spells[i]
                break
            end
        end
    end
    if useColors and kickSpell then
        self:RegisterEvent("SPELL_UPDATE_COOLDOWN", "Cooldowns")
    else
        self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
    end
end

function F:OnEnable()
    local db = self.db
    showTime = db.casttime
    useColors = db.castbar.colors
    local cd, sh = db.castbar.cooldown, db.castbar.uninterruptible
    cdR, cdG, cdB, shR, shG, shB = cd.r, cd.g, cd.b, sh.r, sh.g, sh.b
    for bar, timer in next, timers do
        timer:SetShown(showTime)
        if not showTime then
            elapsedBy[bar] = nil
        end
    end
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Added")
    self:RegisterEvent("SPELLS_CHANGED", "UpdateKick")
    self:UpdateKick()
    for _, frame in next, NP.byUnit do
        setup(NP.state[frame])
    end
end

F.OnRefresh = F.OnEnable

function F:Added(_, unit)
    local st = NP.Get(unit)
    if st then
        setup(st)
    end
end

function F:Cooldowns()
    for bar, st in next, active do
        local casting, channel, notInterruptible = false, false, nil
        if st.unit and bar:IsShown() then
            casting, channel, notInterruptible = castInfo(st.unit)
        end
        if casting then
            colorCast(bar, st, channel, notInterruptible)
        else
            active[bar] = nil
        end
    end
end

function F:OnDisable()
    showTime = false
    for _, timer in next, timers do
        timer:Hide()
    end
    for bar in next, active do
        active[bar] = nil
    end
end
