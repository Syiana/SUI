local Module = SUI:NewModule("Skins.LFG");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(PVEFrame, true)
        SUI:Skin(PVEFrame.shadows, true)
        SUI:Skin(PVEFrame.NineSlice, true)
        SUI:Skin(LFGListFrame.SearchPanel.ResultsInset, true)
        SUI:Skin(LFGListFrame.SearchPanel.ResultsInset.NineSlice, true)
        SUI:Skin(PVEFrameLeftInset, true)
        SUI:Skin(PVEFrameLeftInset.NineSlice, true)
        SUI:Skin(LFDParentFrameInset, true)
        SUI:Skin(LFDParentFrameInset.NineSlice, true)
        SUI:Skin(RaidFinderFrameRoleInset, true)
        SUI:Skin(RaidFinderFrameRoleInset.NineSlice, true)
        SUI:Skin(RaidFinderFrameBottomInset, true)
        SUI:Skin(RaidFinderFrameBottomInset.NineSlice, true)
        SUI:Skin(LFGListFrame, true)
        SUI:Skin(LFGListFrame.CategorySelection, true)
        SUI:Skin(LFGListFrame.CategorySelection.Inset, true)
        SUI:Skin(LFGListFrame.CategorySelection.Inset.NineSlice, true)
        SUI:Skin(LFGListFrame.ApplicationViewer, true)
        SUI:Skin(LFGListFrame.ApplicationViewer.Inset, true)
        SUI:Skin(LFGListFrame.ApplicationViewer.Inset.NineSlice, true)
        SUI:Skin(LFGListFrame.EntryCreation, true)
        SUI:Skin(LFGListFrame.EntryCreation.Inset, true)
        SUI:Skin(LFGListFrame.EntryCreation.Inset.NineSlice, true)
        SUI:Skin(LFGListFrame.ApplicationViewer.NameColumnHeader, true)
        SUI:Skin(LFGListFrame.ApplicationViewer.RoleColumnHeader, true)
        SUI:Skin(LFGListFrame.ApplicationViewer.ItemLevelColumnHeader, true)
        SUI:Skin(LFGApplicationViewerRatingColumnHeader, true)
        SUI:Skin(LFDRoleCheckPopup, true)
        SUI:Skin(LFDRoleCheckPopup.Border, true)
        SUI:Skin(PVPReadyDialog, true)
        SUI:Skin(PVPReadyDialog.Border, true)

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_PVPUI" then
                SUI:Skin(PlunderstormFrame.Inset, true)
                SUI:Skin(PlunderstormFrame.Inset.NineSlice, true)
            end
        end)

        SUI:Skin({
            LFDQueueFrameBackground,
            LFDParentFrameRoleBackground,
            PVEFrameTopFiligree,
            PVEFrameBottomFiligree,
            PVEFrameBlueBg,
        }, true, true)

        -- Tabs
        SUI:Skin(PVEFrameTab1, true)
        SUI:Skin(PVEFrameTab2, true)
        SUI:Skin(PVEFrameTab3, true)
        SUI:Skin(PVEFrameTab4, true)
    end
end
