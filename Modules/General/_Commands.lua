local Module = SUI:NewModule("General.Commands");

function Module:OnEnable()
  SlashCmdList["RELOAD"] = function()
    ReloadUI()
  end
  SLASH_RELOAD1 = "/rl"
  SlashCmdList["SUI"] = function()
    SUI:Config()
  end
  SLASH_SUI1 = "/sui"
end