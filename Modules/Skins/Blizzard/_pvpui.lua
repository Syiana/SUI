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
        SUI:Skin(PVPConquestFrame)
        SUI:Skin(PVPTeamManagementFrame)
        SUI:Skin(PVPTeam1)
        SUI:Skin(PVPTeam2)
        SUI:Skin(PVPTeam3)
        SUI:Skin(WorldStateScoreFrame)
        SUI:Skin(WorldStateScoreFrameTab1)
        SUI:Skin(WorldStateScoreFrameTab2)
        SUI:Skin(WorldStateScoreFrameTab3)
        SUI:Skin(PVPConquestFrameInfoButton)
        SUI:Skin(PVPFrameConquestBar)
        --[[SUI:Skin({
            PVPFrameConquestBarBG,
            PVPFrameConquestBarLeft,
            PVPFrameConquestBarMiddle,
            PVPFrameConquestBarRight
        }, false, true)]]

        -- PVP Frame Texts
        PVPHonorFrameInfoScrollFrameChildFrameDescription:SetTextColor(.8, .8, .8)
        PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoDescription:SetTextColor(.8, .8, .8)
        WarGamesFrameDescription:SetTextColor(.8, .8, .8)

        -- Buttons
        SUI:Skin({
            PVPFrameLeftButton.Left,
            PVPFrameLeftButton.Middle,
            PVPFrameLeftButton.Right,
            PVPFrameRightButton.Left,
            PVPFrameRightButton.Middle,
            PVPFrameRightButton.Right,
            WarGameStartButton.Left,
            WarGameStartButton.Middle,
            WarGameStartButton.Right,
            WorldStateScoreFrameLeaveButton.Left,
            WorldStateScoreFrameLeaveButton.Middle,
            WorldStateScoreFrameLeaveButton.Right
        }, false, true, false, true)
    end
end
