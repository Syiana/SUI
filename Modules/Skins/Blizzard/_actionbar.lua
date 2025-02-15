local Module = SUI:NewModule("Skins.ActionBar");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(MainMenuBar, true)
        SUI:Skin(MainMenuBar.EndCaps, true)
        SUI:Skin(MainMenuBar.ActionBarPageNumber.UpButton, true)
        SUI:Skin(MainMenuBar.ActionBarPageNumber.DownButton, true)
        MainMenuBar.ActionBarPageNumber.Text:SetVertexColor(unpack(SUI:Color(0.15)))
        SUI:Skin(StatusTrackingBarManager, true)
        SUI:Skin(StatusTrackingBarManager.BottomBarFrameTexture, true)
        SUI:Skin(StatusTrackingBarManager.MainStatusTrackingBarContainer, true)
        SUI:Skin(StatusTrackingBarManager.SecondaryStatusTrackingBarContainer, true)
    end
end
