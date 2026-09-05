--[[
    SUI 2.0 - Core/Commands.lua

    Slash commands:
      /sui              open the options
      /sui <category>   open a specific category (e.g. /sui unitframes)
      /sui unlock|lock  classic frame movers
      /sui reset        reset the current profile
      /sui debug        toggle debug output
      /rl               reload the UI
      /fs               frame stack
]]

local function openConfig(category)
    if SUI.Config and SUI.Config.Toggle then
        if category and category ~= "" then
            SUI.Config:Open(category)
        else
            SUI.Config:Toggle()
        end
    end
end

SUI:RegisterChatCommand("sui", function(input)
    local cmd, rest = strsplit(" ", strtrim(input or ""), 2)
    cmd = (cmd or ""):lower()

    if cmd == "" then
        openConfig()
    elseif cmd == "unlock" then
        SUI.EditMode:SetUnlocked(true)
    elseif cmd == "lock" then
        SUI.EditMode:SetUnlocked(false)
    elseif cmd == "edit" or cmd == "move" then
        SUI.EditMode:Open()
    elseif cmd == "reset" then
        SUI:Confirm("Reset the current profile to defaults?", function()
            SUI.db:ResetProfile()
            ReloadUI()
        end)
    elseif cmd == "debug" then
        SUI.db.profile.debug = not SUI.db.profile.debug
        SUI:Print("Debug output", SUI.db.profile.debug and "enabled" or "disabled")
    elseif cmd == "install" then
        SUI.db.profile.install = false
        ReloadUI()
    elseif cmd == "version" then
        SUI:Print("Version", SUI.version, "(" .. SUI.Flavor .. ")")
    elseif cmd == "help" then
        SUI:Print("/sui - options | /sui <category> | /sui edit | /sui unlock | /sui reset | /sui version")
    else
        openConfig(cmd)
    end
end)

SUI:RegisterChatCommand("rl", function() ReloadUI() end)
SUI:RegisterChatCommand("reloadui", function() ReloadUI() end)

SUI:RegisterChatCommand("fs", function(msg)
    SUI.API.LoadDebugTools()
    if not FrameStackTooltip_Toggle then
        return
    end
    local pattern = "^%s*(%S+)(.*)$"
    local showHiddenArg, showRegionsArg, showAnchorsArg
    showHiddenArg, msg = string.match(msg or "", pattern)
    showRegionsArg, msg = string.match(msg or "", pattern)
    showAnchorsArg, msg = string.match(msg or "", pattern)
    local showHidden = StringToBoolean(showHiddenArg or "", FrameStackTooltip_IsShowHiddenEnabled and FrameStackTooltip_IsShowHiddenEnabled() or false)
    local showRegions = StringToBoolean(showRegionsArg or "", FrameStackTooltip_IsShowRegionsEnabled and FrameStackTooltip_IsShowRegionsEnabled() or false)
    local showAnchors = StringToBoolean(showAnchorsArg or "", FrameStackTooltip_IsShowAnchorsEnabled and FrameStackTooltip_IsShowAnchorsEnabled() or false)
    FrameStackTooltip_Toggle(showHidden, showRegions, showAnchors)
end)

-- Addon compartment / minimap entry point.
_G.SUI_Options = function()
    openConfig()
end
