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
        SUI:Skin(AddonCharacterDropDown)

        -- Buttons
        SUI:Skin({
            AddonListEnableAllButton.Left,
            AddonListEnableAllButton.Middle,
            AddonListEnableAllButton.Right,
            AddonListDisableAllButton.Left,
            AddonListDisableAllButton.Middle,
            AddonListDisableAllButton.Right,
            AddonListOkayButton.Left,
            AddonListOkayButton.Middle,
            AddonListOkayButton.Right,
            AddonListCancelButton.Left,
            AddonListCancelButton.Middle,
            AddonListCancelButton.Right
        }, false, true, false, true)
    end
end
