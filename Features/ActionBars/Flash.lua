--[[
    SUI 2.0 - Features/ActionBars/Flash.lua

    A short star flash on an action button when its key binding is pressed
    (SUI 1.x "Flash Animation"). Five animation frames are built once and
    reused in turn, so pressing keys creates no garbage.
]]

local _, ns = ...
local SUI = ns.SUI

local _G = _G

local F = SUI:NewFeature("ActionBars.Flash", {
    category = "actionbar",
    toggle = "buttons.flash",
})

local POOL = 5
local pool, nextIndex = {}, 1

local function play(button)
    if not button or not button:IsVisible() or button:GetEffectiveAlpha() < 1 then
        return
    end
    local anim = pool[nextIndex]
    nextIndex = nextIndex % POOL + 1
    anim.frame:SetAllPoints(button)
    anim.group:Stop()
    anim.group:Play()
end

local function build()
    for i = 1, POOL do
        local frame = CreateFrame("Frame", nil, UIParent)
        frame:SetFrameStrata("HIGH")
        frame:SetFrameLevel(20)
        local texture = frame:CreateTexture(nil, "OVERLAY")
        texture:SetTexture([[Interface\Cooldown\star4]])
        texture:SetBlendMode("ADD")
        texture:SetAllPoints()
        texture:SetAlpha(0)

        local group = texture:CreateAnimationGroup()
        local fadeIn = group:CreateAnimation("Alpha")
        fadeIn:SetFromAlpha(0)
        fadeIn:SetToAlpha(1)
        fadeIn:SetDuration(0)
        fadeIn:SetOrder(1)
        local grow = group:CreateAnimation("Scale")
        grow:SetScale(1.5, 1.5)
        grow:SetDuration(0.3)
        grow:SetOrder(2)
        local spin = group:CreateAnimation("Rotation")
        spin:SetDegrees(90)
        spin:SetDuration(0.3)
        spin:SetOrder(2)

        pool[i] = { frame = frame, group = group }
    end
end

function F:OnLoad()
    build()

    if ActionButtonDown then
        self:Hook("ActionButtonDown", function(id)
            if C_PetBattles and C_PetBattles.IsInBattle() then
                return
            end
            local override = OverrideActionBar
            if override and override:IsShown() then
                play(_G["OverrideActionBarButton" .. id])
            else
                play(_G["ActionButton" .. id])
            end
        end)
    end

    if MultiActionButtonDown then
        self:Hook("MultiActionButtonDown", function(bar, id)
            play(_G[bar .. "Button" .. id])
        end)
    end

    local petBar = PetActionBar
    if petBar and petBar.PetActionButtonDown then
        self:Hook(petBar, "PetActionButtonDown", function(_, id)
            play(_G["PetActionButton" .. id])
        end)
    elseif PetActionButtonDown then
        self:Hook("PetActionButtonDown", function(id)
            play(_G["PetActionButton" .. id])
        end)
    end
end
