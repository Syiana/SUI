local Module = SUI:NewModule("Skins.ActionBar");

function Module:OnEnable()
  if (SUI:Color()) then
    local frameList = {
      StanceBarLeft,
      StanceBarMiddle,
      StanceBarRight
    }
    
    SUI:Skin(MainMenuBarArtFrame)
    SUI:Skin(MainMenuExpBar)
    SUI:Skin(ActionBarUpButton, true)
    SUI:Skin(ActionBarDownButton, true)
    SUI:Skin(frameList, true, true)
  end
end