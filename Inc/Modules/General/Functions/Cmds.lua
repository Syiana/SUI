local ADDON, SUI = ...
SUI.MODULES.GENERAL.Cmds = function(state) 
    if (state) then
        SlashCmdList["RELOAD"] = function()
            ReloadUI()
        end
        SLASH_RELOAD1 = "/rl"
    end
end