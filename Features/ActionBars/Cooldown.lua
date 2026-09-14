--[[
    SUI 2.0 - Features/ActionBars/Cooldown.lua

    Desaturates action button icons while the action is on a real cooldown
    (longer than the global cooldown and without charges left). Updates are
    driven by the cooldown and action bar events only.
]]

local _, ns = ...
local SUI = ns.SUI
local AB = ns.ActionBars

local CanAccess = SUI.Compat.CanAccess

local F = SUI:NewFeature("ActionBars.Cooldown", {
    category = "actionbar",
    toggle = "buttons.desaturate",
})

local buttons = {}
local onCooldown -- function(button, action) -> bool, resolved per client in OnLoad

function F:OnLoad()
    buttons = AB.AllButtons(true)
    local api = C_ActionBar
    if api and api.GetActionCooldown then
        -- Retail: tables, values may be secret inside restricted content.
        local GetCooldown, GetCharges = api.GetActionCooldown, api.GetActionCharges
        onCooldown = function(button, action)
            local charges = GetCharges and GetCharges(action)
            if charges and CanAccess(charges.maxCharges) and CanAccess(charges.currentCharges)
                and charges.maxCharges > 1 and charges.currentCharges > 0 then
                return false
            end
            local info = GetCooldown(action)
            if not info then
                return false
            end
            if CanAccess(info.duration) then
                return info.duration > 1.5
            end
            local cooldown = button.cooldown
            return cooldown ~= nil and cooldown:IsShown() and CanAccess(info.isOnGCD) and not info.isOnGCD
        end
    else
        local GetCooldown, GetCharges = GetActionCooldown, GetActionCharges
        onCooldown = function(_, action)
            if GetCharges then
                local current, maximum = GetCharges(action)
                if maximum and maximum > 1 and current > 0 then
                    return false
                end
            end
            local _, duration = GetCooldown(action)
            return duration ~= nil and duration > 1.5
        end
    end
end

function F:Update()
    for i = 1, #buttons do
        local button = buttons[i]
        local action, icon = button.action, button.icon
        if icon and action and button:IsVisible() then
            icon:SetDesaturated(onCooldown(button, action))
        end
    end
end

function F:OnEnable()
    self:RegisterEvent("SPELL_UPDATE_COOLDOWN", "Update")
    self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN", "Update")
    self:RegisterEvent("ACTIONBAR_SLOT_CHANGED", "Update")
    self:RegisterEvent("ACTIONBAR_PAGE_CHANGED", "Update")
    self:RegisterEvent("UPDATE_BONUS_ACTIONBAR", "Update")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Update")
    self:Update()
end

function F:OnDisable()
    for i = 1, #buttons do
        local icon = buttons[i].icon
        if icon then
            icon:SetDesaturated(false)
        end
    end
end
