local Module = SUI:NewModule("General.Commands");

function Module:OnEnable()
    local db = SUI.db

    SlashCmdList["RELOAD"] = function()
        ReloadUI()
    end
    SLASH_RELOAD1 = "/rl"
    SlashCmdList["SUI"] = function()
        SUI:Config()
    end
    SLASH_SUI1 = "/sui"

    SlashCmdList["SUIRESET"] = function()
        db:ResetProfile()
        ReloadUI()
    end
    SLASH_SUIRESET1 = "/sui:reset"
end
