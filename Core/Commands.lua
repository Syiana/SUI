--[[
    SUI 2.0 - Core/Commands.lua

    /sui              open or close the options
    /sui <tab>        open a tab, e.g. /sui chat
    /sui unlock|lock  move SUI frames (classic) / open Edit Mode (retail)
    /sui install      show the welcome screen again
    /sui reset        reset the current profile
    /sui version      print the installed version
    /sui debug        toggle debug output
    /rl               reload the interface (only if no other add-on owns it)
    /fs               frame stack tooltip (only if no other add-on owns it)
]]

local _, ns = ...
local SUI = ns.SUI

local strtrim, strsplit = strtrim, strsplit

StaticPopupDialogs["SUI_RESET_PROFILE"] = {
    text = "|cffea00ffS|r|cff00a2ffUI|r: Reset the current profile to its defaults?",
    button1 = YES or "Yes",
    button2 = NO or "No",
    OnAccept = function()
        SUI.db:ResetProfile()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

local function handle(input)
    local cmd, rest = strsplit(" ", strtrim(input or ""), 2)
    cmd = (cmd or ""):lower()

    if cmd == "" then
        SUI.Config:Toggle()
    elseif cmd == "unlock" or cmd == "move" or cmd == "edit" then
        SUI.Movers:SetUnlocked(true)
    elseif cmd == "lock" then
        SUI.Movers:SetUnlocked(false)
    elseif cmd == "install" then
        SUI.Config:ShowInstall()
    elseif cmd == "reset" then
        StaticPopup_Show("SUI_RESET_PROFILE")
    elseif cmd == "version" then
        SUI:Print("Version", SUI.version, "(" .. SUI.Client .. ")")
    elseif cmd == "debug" then
        SUI.db.global.debug = not SUI.db.global.debug
        SUI:Print("Debug output", SUI.db.global.debug and "enabled" or "disabled")
    elseif cmd == "help" then
        SUI:Print("/sui, /sui <tab>, /sui unlock, /sui lock, /sui install, /sui reset, /sui version")
    else
        SUI.Config:Open(cmd, rest)
    end
end

SUI:RegisterChatCommand("sui", handle)

-- Only claim /rl when nobody else did.
if not (hash_SlashCmdList and hash_SlashCmdList["/RL"]) then
    SUI:RegisterChatCommand("rl", function()
        ReloadUI()
    end)
end

-- Frame stack tooltip, like 1.x.
if not (hash_SlashCmdList and hash_SlashCmdList["/FS"]) then
    SUI:RegisterChatCommand("fs", function(msg)
        if not FrameStackTooltip_Toggle then
            local load = UIParentLoadAddOn or SUI.Compat.LoadAddOn
            load("Blizzard_DebugTools")
        end
        if not FrameStackTooltip_Toggle then
            return
        end
        local pattern = "^%s*(%S+)(.*)$"
        local hidden, regions, anchors
        hidden, msg = string.match(msg or "", pattern)
        regions, msg = string.match(msg or "", pattern)
        anchors = string.match(msg or "", pattern)
        local function flag(arg, default)
            if StringToBoolean then
                return StringToBoolean(arg or "", default)
            end
            return default
        end
        FrameStackTooltip_Toggle(
            flag(hidden, FrameStackTooltip_IsShowHiddenEnabled and FrameStackTooltip_IsShowHiddenEnabled()),
            flag(regions, FrameStackTooltip_IsShowRegionsEnabled and FrameStackTooltip_IsShowRegionsEnabled()),
            flag(anchors, FrameStackTooltip_IsShowAnchorsEnabled and FrameStackTooltip_IsShowAnchorsEnabled())
        )
    end)
end

-- Addon compartment (retail) entry.
function SUI_Options()
    SUI.Config:Toggle()
end
