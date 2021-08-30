local Module = SUI:NewModule("General.Commands");

function Module:OnEnable()
  local db = SUI.db.profile.general
  if (db) then
      SlashCmdList["RELOAD"] = function()
          ReloadUI()
      end
      SLASH_RELOAD1 = "/rl"
  end
end