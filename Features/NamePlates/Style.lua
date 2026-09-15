--[[
    SUI 2.0 - Features/NamePlates/Style.lua

    Health bar texture with the focus highlight texture, and hiding the
    Blizzard debuff row. Textures are set when a plate appears; a hook on the
    bar's own SetStatusBarTexture puts ours back when Blizzard resets it.
]]

local _, ns = ...
local SUI = ns.SUI
local NP = ns.NamePlates

local next, hooksecurefunc = next, hooksecurefunc

local isCustom = NP.isCustom

-- Texture and focus highlight ---------------------------------------------------------
local T = SUI:NewFeature("NamePlates.Texture", {
    category = "nameplates",
    toggle = isCustom,
    conflicts = NP.conflicts,
    reload = true, -- Blizzard's texture cannot be restored reliably
})

local FOCUS = SUI.Media.textures .. [[Nameplates\focusTexture]]
local texture, useFocus, focusFrame
local barState = {} -- health bar -> plate state (hook installed)
local applying = false

local onSetTexture

local function apply(st)
    local bar = st.healthBar
    if not bar then
        return
    end
    if not barState[bar] then
        barState[bar] = st
        hooksecurefunc(bar, "SetStatusBarTexture", onSetTexture)
    end
    applying = true
    bar:SetStatusBarTexture((useFocus and st.frame == focusFrame) and FOCUS or texture)
    applying = false
    local frame = st.frame
    if frame.myHealPrediction then
        frame.myHealPrediction:SetTexture(texture)
        frame.myHealPrediction:SetVertexColor(16 / 510, 424 / 510, 400 / 510)
    end
    if frame.otherHealPrediction then
        frame.otherHealPrediction:SetTexture(texture)
        frame.otherHealPrediction:SetVertexColor(0, 325 / 510, 292 / 510)
    end
    if frame.totalAbsorb then
        frame.totalAbsorb:SetTexture(texture)
    end
end

function onSetTexture(bar)
    if applying or not T.enabled then
        return
    end
    local st = barState[bar]
    if st.unit then
        apply(st)
    end
end

local function focusUnitFrame()
    local plate = C_NamePlate.GetNamePlateForUnit("focus")
    return plate and plate.UnitFrame
end

function T:OnEnable()
    self:Settings()
    focusFrame = focusUnitFrame()
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Added")
    self:RegisterEvent("PLAYER_FOCUS_CHANGED", "Focus")
    self:ApplyAll()
end

function T:Settings()
    local tex = self.db.texture
    texture = (tex and tex ~= [[Interface\Default]]) and tex or SUI.Media.statusbar
    useFocus = self.db.focusHighlight
end

function T:ApplyAll()
    for _, frame in next, NP.byUnit do
        apply(NP.state[frame])
    end
end

function T:OnRefresh()
    self:Settings()
    self:ApplyAll()
end

function T:Added(_, unit)
    local st = NP.Get(unit)
    if st then
        if useFocus then
            focusFrame = focusUnitFrame()
        end
        apply(st)
    end
end

function T:Focus()
    local old = focusFrame
    focusFrame = focusUnitFrame()
    if old and NP.state[old] and NP.state[old].unit then
        apply(NP.state[old])
    end
    local st = focusFrame and NP.state[focusFrame]
    if st and st.unit then
        apply(st)
    end
end

-- Hide debuffs ------------------------------------------------------------------------
local D = SUI:NewFeature("NamePlates.HideDebuffs", {
    category = "nameplates",
    toggle = function(db)
        return isCustom(db) and db.debuffs
    end,
    conflicts = NP.conflicts,
})

local hidden = {}

local function hide(st)
    local auras = st.frame.BuffFrame or st.frame.AurasFrame
    if auras then
        auras:SetAlpha(0)
        hidden[auras] = true
    end
end

function D:OnEnable()
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Added")
    for _, frame in next, NP.byUnit do
        hide(NP.state[frame])
    end
end

function D:Added(_, unit)
    local st = NP.Get(unit)
    if st then
        hide(st)
    end
end

function D:OnDisable()
    for auras in next, hidden do
        auras:SetAlpha(1)
        hidden[auras] = nil
    end
end
