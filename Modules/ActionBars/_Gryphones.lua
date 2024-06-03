local Gryphones = SUI:NewModule("ActionBars.Gryphones");

function Gryphones:OnEnable()
  local db = SUI.db.profile.actionbar

  if (db.gryphones) then
    MainMenuBarArtFrame.LeftEndCap:Show()
    MainMenuBarArtFrame.RightEndCap:Show()
  else
    MainMenuBarArtFrame.LeftEndCap:Hide()
    MainMenuBarArtFrame.RightEndCap:Hide()
  end

end