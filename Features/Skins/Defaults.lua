--[[
    SUI 2.0 - Features/Skins/Defaults.lua

    Settings of the Skins tab. SUI 1.x skinned everything unconditionally,
    so there are no 1.x keys to migrate; every toggle defaults to on.
]]

local _, ns = ...
local SUI = ns.SUI

SUI:RegisterDefaults("skins", {
    blizzard = true,
    details = true,
    bartender = true,
    classicui = true,
})
