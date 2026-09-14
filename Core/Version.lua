--[[
    SUI 2.0 - Core/Version.lua

    Shares the installed version with group and guild members and tells the
    player once per session when someone runs a newer build. Versions are
    compared numerically ("2.10.0" is newer than "2.9.3").
]]

local _, ns = ...
local SUI = ns.SUI

local PREFIX = "SUIVersion"
local announced = false

local function toNumber(version)
    if type(version) ~= "string" then
        return 0
    end
    local a, b, c = version:match("(%d+)%.(%d+)%.?(%d*)")
    return (tonumber(a) or 0) * 1000000 + (tonumber(b) or 0) * 1000 + (tonumber(c) or 0)
end
SUI.VersionToNumber = toNumber

local function groupChannel()
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        return "INSTANCE_CHAT"
    elseif IsInRaid() then
        return "RAID"
    elseif IsInGroup() then
        return "PARTY"
    end
end

function SUI:SendVersion(channel)
    if not channel or self.Compat.IsRestrictedContext() then
        return
    end
    -- Development builds carry an unreplaced token; do not advertise them.
    if toNumber(self.version) == 0 then
        return
    end
    self:SendCommMessage(PREFIX, self.version, channel)
end

function SUI:OnVersionReceived(_, version)
    if announced or toNumber(version) <= toNumber(self.version) then
        return
    end
    announced = true
    self.db.global.newVersion = version
    self:Print("Version " .. version .. " is available. Updating is recommended.")
end

SUI.callbacks.RegisterCallback(SUI, "Ready", function()
    local global = SUI.db.global
    if global.newVersion and toNumber(global.newVersion) <= toNumber(SUI.version) then
        global.newVersion = false
    end

    SUI:RegisterComm(PREFIX, "OnVersionReceived")
    SUI:RegisterEvent("GROUP_ROSTER_UPDATE", function()
        SUI:Throttle("version-group", 10, function()
            SUI:SendVersion(groupChannel())
        end)
    end)
    C_Timer.After(20, function()
        SUI:SendVersion(groupChannel())
        if IsInGuild() then
            SUI:SendVersion("GUILD")
        end
    end)
end)
