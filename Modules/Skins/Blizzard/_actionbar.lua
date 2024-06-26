local Module = SUI:NewModule("Skins.ActionBar");

function Module:OnEnable()
    if (SUI:Color()) then
        local frameList = {
            StanceBarLeft,
            StanceBarMiddle,
            StanceBarRight,
            OverrideActionBarHealthBarOverlay,
            OverrideActionBarHealthBarBackground,
            OverrideActionBarPowerBarOverlay,
            OverrideActionBarPowerBarBackground
        }

        SUI:Skin(MainMenuBarArtFrame)
        SUI:Skin(MainMenuExpBar)
        SUI:Skin(ActionBarUpButton, true)
        SUI:Skin(ActionBarDownButton, true)
        SUI:Skin(MainMenuBarMaxLevelBar)
        SUI:Skin(frameList, true, true)
        SUI:Skin(OverrideActionBar)
        SUI:Skin(OverrideActionBarExpBarOverlayFrame)
        SUI:Skin(OverrideActionBarExpBar)
        SUI:Skin(RetailUIArtFrame)
        SUI:Skin(PetActionBarFrame)
    end
end
