--[[
    SUI 2.0 - Features/Misc/Defaults.lua

    Defaults for the Misc tab. The 1.x keys keep their names; misc.repbar
    belongs to ActionBars now. Tab Binder remembers per character which keys
    it moved, so it only ever gives back what it took.
]]

local _, ns = ...
local SUI = ns.SUI

SUI:RegisterDefaults("misc", {
    -- SUI 1.x
    safequeue = true,
    tabbinder = false,
    pulltimer = false,
    interrupt = false,
    dampening = true,
    arenanameplate = false,
    surrender = false,
    losecontrol = false,
    menubutton = true,
    dragonflying = true,
    -- SUI 2.0
    fastloot = false,
    lfgdeclined = false,
    achievements = false,
    playerlinks = true,
    playerlinkslfg = false,
})

SUI:RegisterDefaults("misc", {
    tabbinder = {}, -- key -> action it was bound to before PvP
}, "char")
