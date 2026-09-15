--[[
    SUI 2.0 - Features/Tooltip/Defaults.lua

    Settings of the Tooltip tab. The first four keys are the SUI 1.x keys, the
    rest are new in 2.0. Also holds the one helper every tooltip file needs:
    finding the unit of a unit tooltip without touching secret values.
]]

local _, ns = ...
local SUI = ns.SUI

SUI:RegisterDefaults("tooltip", {
    style = "Custom",      -- "Default" | "Custom"
    lifeontop = true,      -- health bar at the top of the tooltip (Custom)
    mouseanchor = false,
    hideincombat = false,
    -- new in 2.0
    texture = SUI.mediaPath .. [[Textures\Tooltip\UI-TargetingFrame-BarFill_test]],
    ids = true,            -- spell and macro id lines (1.x, Custom style)
    -- new in 2.0, off by default like 1.x had none of them
    itemids = false,       -- item and NPC id lines
    itemlevel = false,     -- item level of players (Mainline, Mists)
    mythicplus = false,    -- Mythic+ rating of players (Mainline)
    pvprating = false,     -- arena/shuffle rating of players, needs an inspect (Mainline)
    lfgtooltips = false,   -- group finder leader rating and applicant tooltips (Mainline)
})

-- 1.x profiles keep 1.x behaviour even if these defaults change later. Only
-- unset keys are written, so a choice the user already made survives.
local NEW_INFO = { "itemids", "itemlevel", "mythicplus", "pvprating", "lfgtooltips" }
SUI:RegisterMigration("tooltip-1x-new-info-off", function(profile)
    local tooltip = rawget(profile, "tooltip")
    if type(tooltip) ~= "table" then
        return -- fresh profile: the defaults apply
    end
    for i = 1, #NEW_INFO do
        if rawget(tooltip, NEW_INFO[i]) == nil then
            tooltip[NEW_INFO[i]] = false
        end
    end
end)

-- 1.x only showed id lines with the Custom style.
SUI:RegisterMigration("tooltip-1x-ids", function(profile)
    local tooltip = rawget(profile, "tooltip")
    if type(tooltip) == "table" and tooltip.style == "Default" and rawget(tooltip, "ids") == nil then
        tooltip.ids = false
    end
end)

-- Unit token of a unit tooltip, or nil when it is unknown or secret.
local CanAccess = SUI.Compat.CanAccess
local UnitExists = UnitExists
local hasMotionFocus = WorldFrame and WorldFrame.IsMouseMotionFocus ~= nil

function ns.TooltipUnit(tooltip)
    local _, unit = tooltip:GetUnit()
    if unit and CanAccess(unit) then
        return unit
    end
    -- Midnight can hide the token of world units; the mouseover token still works.
    if hasMotionFocus and WorldFrame:IsMouseMotionFocus() then
        local exists = UnitExists("mouseover")
        if CanAccess(exists) and exists then
            return "mouseover"
        end
    end
end
