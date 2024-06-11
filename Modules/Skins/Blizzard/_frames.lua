local Module = SUI:NewModule("Skins.Frames");

function Module:OnEnable()
  if (SUI:Color()) then
    SUI:Skin(GameMenuFrame)
    SUI:Skin(GameMenuButtonHelp)
    SUI:Skin(GameMenuButtonStore)
    SUI:Skin(GameMenuButtonOptions)
    SUI:Skin(GameMenuButtonMacros)
    SUI:Skin(GameMenuButtonAddons)
    SUI:Skin(GameMenuButtonLogout)
    SUI:Skin(GameMenuButtonQuit)
    SUI:Skin(GameMenuButtonContinue)
    SUI:Skin(SUIMenuButton)
    SUI:Skin(StaticPopup1)
    SUI:Skin(StaticPopup1Button1)
    SUI:Skin(StaticPopup1Button2)
    SUI:Skin(HelpFrame)
    SUI:Skin(HelpFrame.NineSlice)
  end
end