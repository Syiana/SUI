local Module = SUI:NewModule("Skins.ActionBar");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(MainActionBar, true)
        SUI:Skin(MainActionBar.EndCaps, true)
        SUI:Skin(MainActionBar.ActionBarPageNumber.UpButton, true)
        SUI:Skin(MainActionBar.ActionBarPageNumber.DownButton, true)
        MainActionBar.ActionBarPageNumber.Text:SetVertexColor(unpack(SUI:Color(0.15)))
        SUI:Skin(StatusTrackingBarManager, true)
        SUI:Skin(StatusTrackingBarManager.BottomBarFrameTexture, true)
        SUI:Skin(StatusTrackingBarManager.MainStatusTrackingBarContainer, true)
        SUI:Skin(StatusTrackingBarManager.SecondaryStatusTrackingBarContainer, true)
    end
end
