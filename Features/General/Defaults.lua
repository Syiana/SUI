--[[
    SUI 2.0 - Features/General/Defaults.lua

    Settings of the General tab. theme, color, font and texture belong to
    Core/Theme.lua; everything else keeps its SUI 1.x key. New in 2.0:
    automation.rolecheck/quests/gossip and cosmetic.cursor.
]]

local _, ns = ...
local SUI = ns.SUI

SUI:RegisterDefaults("general", {
    automation = {
        delete = true,
        decline = false,
        repair = "Disabled", -- "Disabled" | "Player" | "Guild"
        sell = true,
        stackbuy = true,
        invite = false,
        release = false,
        resurrect = false,
        cinematic = false,
        rolecheck = false,
        quests = false,
        gossip = false,
    },
    cosmetic = {
        afkscreen = true,
        talkhead = false, -- false hides the talking head (1.x meaning)
        errors = false,   -- false filters UI error messages (1.x meaning)
        cursor = false,
    },
    display = {
        ilvl = true,
        fps = true,
        ms = true,
        movementSpeed = false,
    },
})

-- 1.x used "Default" for "do not repair". 2.0 has no "Default" value, so
-- mapping it again is harmless (idempotent).
SUI:RegisterMigration("general-1x-repair", function(profile)
    local general = rawget(profile, "general")
    local automation = type(general) == "table" and rawget(general, "automation")
    if type(automation) == "table" and automation.repair == "Default" then
        automation.repair = "Disabled"
    end
end)

-- Some 1.x profiles stored the talking head switch as cosmetic.talkinghead.
SUI:RegisterMigration("general-1x-talkinghead", function(profile)
    local general = rawget(profile, "general")
    local cosmetic = type(general) == "table" and rawget(general, "cosmetic")
    if type(cosmetic) == "table" and rawget(cosmetic, "talkinghead") ~= nil then
        cosmetic.talkhead = cosmetic.talkinghead and true or false
        cosmetic.talkinghead = nil
    end
end)
