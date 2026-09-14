--[[
    SUI 2.0 - Features/ActionBars/Defaults.lua

    Settings of the Actionbar tab. The keys are the SUI 1.x keys; the only
    move is the XP/reputation bar toggle, which lived in misc.repbar.
]]

local _, ns = ...
local SUI = ns.SUI

SUI:RegisterDefaults("actionbar", {
    buttons = {
        key = true,         -- show hotkey text
        macro = true,       -- show macro text
        range = true,       -- range/usability colouring
        flash = false,      -- flash animation on key press
        size = 12,          -- button text size
        desaturate = false, -- grey out icons while on cooldown (new in 2.0)
        procglow = "Blizzard",  -- "Blizzard" | "Custom" | "Hide" (new in 2.0)
        procglowstyle = "Pixel", -- "Pixel" | "Autocast" | "Button"
        procglowtheme = true,   -- custom glow uses the theme/class colour
        procglowcolor = { r = 0.95, g = 0.95, b = 0.32, a = 1 },
    },
    menu = {
        micromenu = "show", -- "show" | "mouse_over" | "hide"
        bagbar = "show",
    },
    bars = {
        bar1 = false, bar2 = false, bar3 = false, bar4 = false,
        bar5 = false, bar6 = false, bar7 = false, bar8 = false,
        petbar = false, stancebar = false,
    },
    gryphons = false,  -- hide gryphons / end caps (new in 2.0)
    statusbar = false, -- hide XP/reputation/honor bars (1.x: misc.repbar)
})

SUI:RegisterMigration("actionbar-1x-repbar", function(profile)
    local misc = rawget(profile, "misc")
    if type(misc) ~= "table" or misc.repbar == nil then
        return
    end
    local actionbar = profile.actionbar
    if type(actionbar) ~= "table" then
        actionbar = {}
        profile.actionbar = actionbar
    end
    actionbar.statusbar = misc.repbar and true or false
    misc.repbar = nil
end)
