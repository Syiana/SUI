--[[ SUI 2.0 - Features/UnitFrames/Overshields.lua
    Retail only. Blizzard shows a glow when absorbs exceed missing health but
    no shield on the full bar. A striped bar filling from the right edge of
    the health bar shows the whole absorb while that glow is visible. It is
    updated from UnitFrameHealPredictionBars_Update, which Blizzard already
    calls on every health or absorb change; values go straight into the
    statusbar, so secret values in instances are fine.
]]

local _, ns = ...
local SUI = ns.SUI

local _G, UnitHealthMax, UnitGetTotalAbsorbs = _G, UnitHealthMax, UnitGetTotalAbsorbs

local F = SUI:NewFeature("UnitFrames.Overshields", {
    category = "unitframes",
    clients = { Mainline = true },
    toggle = "overshields",
})

local SHIELD = [[Interface\RaidFrame\Shield-Overlay]]
local bars = {} -- unit frame -> absorb statusbar

local function update(frame)
    local bar = bars[frame]
    if not bar then
        return
    end
    local glow, unit = frame.overAbsorbGlow, frame.unit
    if glow and unit and glow:IsShown() then
        bar:SetMinMaxValues(0, UnitHealthMax(unit))
        bar:SetValue(UnitGetTotalAbsorbs(unit))
        bar:Show()
    else
        bar:Hide()
    end
end

function F:OnLoad()
    for _, name in next, { "PlayerFrame", "TargetFrame", "FocusFrame" } do
        local frame = _G[name]
        local health = frame and frame.healthbar
        if health then
            local bar = CreateFrame("StatusBar", nil, health)
            bar:SetAllPoints(health)
            bar:SetReverseFill(true)
            bar:SetStatusBarTexture(SHIELD)
            bar:SetStatusBarColor(1, 1, 1, 0.5)
            bar:SetFrameLevel(health:GetFrameLevel())
            local texture = bar:GetStatusBarTexture()
            texture:SetTexture(SHIELD, "REPEAT", "REPEAT")
            texture:SetHorizTile(true)
            texture:SetVertTile(true)
            texture:SetDrawLayer("ARTWORK", 1)
            bar:Hide()
            bars[frame] = bar
        end
    end
    if UnitFrameHealPredictionBars_Update then
        self:Hook("UnitFrameHealPredictionBars_Update", update)
    end
end

function F:OnEnable()
    for frame in next, bars do
        update(frame)
    end
end

function F:OnDisable()
    for _, bar in next, bars do
        bar:Hide()
    end
end
