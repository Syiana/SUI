--[[
    SUI 2.0 - Features/Misc/Defaults.lua

    Defaults for the Misc tab. The 1.x keys keep their names; misc.repbar
    belongs to ActionBars now. Tab Binder remembers per character which keys
    it moved, so leaving PvP restores those keys first.
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

-- Misc.ArenaNameplate duplicated nameplates.arenanumber and was removed; an
-- enabled 1.x/2.0 switch turns the nameplate option on.
SUI:RegisterMigration("misc-arenanameplate-merge", function(profile)
    local misc = rawget(profile, "misc")
    if type(misc) ~= "table" then
        return
    end
    if rawget(misc, "arenanameplate") == true then
        local np = rawget(profile, "nameplates")
        if type(np) ~= "table" then
            np = {}
            profile.nameplates = np
        end
        np.arenanumber = true
    end
    misc.arenanameplate = nil
end)
