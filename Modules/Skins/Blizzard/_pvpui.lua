local Module = SUI:NewModule("Skins.PvPUI");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(PVPFrame)
        SUI:Skin(PVPFrameInset)
        SUI:Skin(PVPFrameLeftButton)
        SUI:Skin(PVPFrameRightButton)
        SUI:Skin(PVPFrameTab1)
        SUI:Skin(PVPFrameTab2)
        SUI:Skin(PVPFrameTab3)
        SUI:Skin(PVPFrameTab4)
        SUI:Skin(PVPTeamManagementFrameWeeklyDisplay)
        SUI:Skin(WarGameStartButton)
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

        -- Buttons
        SUI:Skin({
            WorldStateScoreFrameLeaveButton.Left,
            WorldStateScoreFrameLeaveButton.Middle,
            WorldStateScoreFrameLeaveButton.Right
        }, false, true, false, true)
    end
end
