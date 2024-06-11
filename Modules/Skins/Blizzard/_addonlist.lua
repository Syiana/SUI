local Module = SUI:NewModule("Skins.AddonList");

function Module:OnEnable()
  if (SUI:Color()) then
    SUI:Skin(AddonList)
    SUI:Skin(AddonListInset)
    SUI:Skin(AddonListEnableAllButton)
    SUI:Skin(AddonListDisableAllButton)
    SUI:Skin(AddonListOkayButton)
    SUI:Skin(AddonListCancelButton)
    SUI:Skin(AddonListScrollFrame)
  end
end