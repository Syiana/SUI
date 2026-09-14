local Module = SUI:NewModule("Skins.Frames");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(GameMenuFrame, true)
        SUI:Skin(GameMenuFrame.Header, true)
        SUI:Skin(GameMenuFrame.Border, true)
        SUI:Skin(StaticPopup1, true)
        SUI:Skin(StaticPopup1.Border, true)
        SUI:Skin(StaticPopup2, true)
        SUI:Skin(StaticPopup2.Border, true)
        SUI:Skin(StaticPopup3, true)
        SUI:Skin(StaticPopup3.Border, true)
        SUI:Skin(EditModeManagerFrame, true)
        SUI:Skin(EditModeManagerFrame.Border, true)
        SUI:Skin(VehicleSeatIndicator, true)
        SUI:Skin(ReportFrame, true)
        SUI:Skin(ReportFrame.Border, true)
        SUI:Skin(ReadyStatus.Border, true)
        SUI:Skin(LFGDungeonReadyStatus.Border, true)
        SUI:Skin(LFGDungeonReadyDialog, true)
        SUI:Skin(LFGDungeonReadyDialog.Border, true)
        SUI:Skin(PVPMatchScoreboard.Content, true)
        SUI:Skin(QueueStatusFrame, true)
        SUI:Skin(QueueStatusFrame.NineSlice, true)
        SUI:Skin(LFGListInviteDialog, true)
        SUI:Skin(LFGListInviteDialog.Border, true)

        PVPMatchScoreboard:HookScript("OnShow", function()
            SUI:Skin(PVPMatchScoreboard, true)
        end)

        -- Tabs
        SUI:Skin(PVPScoreboardTab1, true)
        SUI:Skin(PVPScoreboardTab2, true)
        SUI:Skin(PVPScoreboardTab3, true)
    end
end
