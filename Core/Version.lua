--[[
    SUI 2.0 - Core/Version.lua

    Broadcasts the installed version to group/guild and reports when someone
    around you runs a newer build.
]]

local PREFIX = "SUIVersion"

local function versionToNumber(v)
    if type(v) ~= "string" then
        return 0
    end
    local a, b, c = v:match("(%d+)%.(%d+)%.?(%d*)")
    return (tonumber(a) or 0) * 1000000 + (tonumber(b) or 0) * 1000 + (tonumber(c) or 0)
end

local function defaultChannel()
    if IsInRaid() then
        return IsInRaid(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "RAID"
    elseif IsInGroup() then
        return IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY"
    elseif IsInGuild() then
        return "GUILD"
    end
    return nil
end

function SUI:SendVersion(channel)
    channel = channel or defaultChannel()
    if channel then
        self:SendCommMessage(PREFIX, self.version or "0", channel)
    end
end

function SUI:ReceiveVersion(_, version)
    local mine = versionToNumber(self.version)
    local theirs = versionToNumber(version)
    if theirs > mine and not self.__newVersionAnnounced then
        self.__newVersionAnnounced = true
        self.db.profile.new_version = version
        self:Print("A newer version (" .. version .. ") is available. Updating is recommended.")
    end
end

SUI.callbacks.RegisterCallback("SUIVersionCheck", "SUI_READY", function()
    SUI:RegisterComm(PREFIX, "ReceiveVersion")
    SUI:RegisterEvent("GROUP_ROSTER_UPDATE", function()
        SUI:Throttle("version", 5, function() SUI:SendVersion() end)
    end)
    C_Timer.After(30, function()
        SUI:SendVersion()
        if IsInGuild() then
            SUI:SendVersion("GUILD")
        end
    end)
    if SUI.db.profile.new_version and versionToNumber(SUI.db.profile.new_version) <= versionToNumber(SUI.version) then
        SUI.db.profile.new_version = false
    end
end)
