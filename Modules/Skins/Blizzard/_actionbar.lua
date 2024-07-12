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
            OverrideActionBarPowerBarBackground,
            ReputationWatchBar.StatusBar.WatchBarTexture0,
            ReputationWatchBar.StatusBar.WatchBarTexture1,
            ReputationWatchBar.StatusBar.WatchBarTexture2,
            ReputationWatchBar.StatusBar.WatchBarTexture3,
            ReputationWatchBar.StatusBar.XPBarTexture0,
            ReputationWatchBar.StatusBar.XPBarTexture1,
            ReputationWatchBar.StatusBar.XPBarTexture2,
            ReputationWatchBar.StatusBar.XPBarTexture3,
        }

        SUI:Skin(MainMenuBarArtFrame)
        SUI:Skin(MainMenuExpBar)
        SUI:Skin(ActionBarUpButton)
        SUI:Skin(ActionBarDownButton)
        SUI:Skin(MainMenuBarMaxLevelBar)
        SUI:Skin(frameList, true, true)
        SUI:Skin(OverrideActionBar)
        SUI:Skin(OverrideActionBarExpBarOverlayFrame)
        SUI:Skin(OverrideActionBarExpBar)
        SUI:Skin(RetailUIArtFrame)
        SUI:Skin(PetActionBarFrame)
        SUI:Skin(RetailUIStatusBars)
        SUI:Skin(ReputationWatchBar)

        -- Buttons
        SUI:Skin({
            select(1, ActionBarUpButton:GetRegions()),
            select(1, ActionBarDownButton:GetRegions())
        }, false, true, false, true)
    end
end
