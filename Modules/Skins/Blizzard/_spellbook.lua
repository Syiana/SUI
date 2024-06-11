local Module = SUI:NewModule("Skins.SpellBook");

function Module:OnEnable()
  if (SUI:Color()) then
    SUI:Skin(SpellBookFrame)
    SUI:Skin(SpellBookFrameTabButton1)
    SUI:Skin(SpellBookFrameTabButton2)
  end
end