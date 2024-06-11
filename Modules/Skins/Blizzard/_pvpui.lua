local Module = SUI:NewModule("Skins.PvPUI");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(PVPFrame)
        SUI:Skin(PVPFrameInset)
        SUI:Skin({ PVPHonorFrameBGTex }, false, true)
        SUI:Skin(PVPFrameLeftButton)
        SUI:Skin(PVPFrameRightButton)
        SUI:Skin(PVPFrameTab1)
        SUI:Skin(PVPFrameTab2)
        SUI:Skin(PVPFrameTab3)
        SUI:Skin(PVPFrameTab4)
        SUI:Skin(PVPTeamManagementFrameWeeklyDisplay)
        SUI:Skin(WarGameStartButton)
        SUI:Skin(PVPHonorFrame.bgTypeScrollBar.Background)
        SUI:Skin(PVPHonorFrameInfoScrollFrameScrollBar)
        SUI:Skin(PVPHonorFrameInfoScrollFrame.ScrollBar)
        SUI:Skin(PVPHonorFrameInfoScrollFrame.ScrollBar.Background)
        SUI:Skin(WarGamesFrame)
        SUI:Skin(WarGamesFrame.scrollBar.Background)
        SUI:Skin(WarGamesFrame.scrollBar)
        SUI:Skin(WarGamesFrameInfoScrollFrameScrollBar)
        SUI:Skin(WarGamesFrameInfoScrollFrame.ScrollBar)
        SUI:Skin(WarGamesFrameInfoScrollFrame.ScrollBar.Background)
    end
end
