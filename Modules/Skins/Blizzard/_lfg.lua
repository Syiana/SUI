local Module = SUI:NewModule("Skins.LFG");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(PVEFrame)
        SUI:Skin(PVEFrame.shadows)
        SUI:Skin(PVEFrame.NineSlice)
        SUI:Skin(LFGListFrame.SearchPanel.ResultsInset)
        SUI:Skin(LFGListFrame.SearchPanel.ResultsInset.NineSlice)
        SUI:Skin(PVEFrameLeftInset)
        SUI:Skin(PVEFrameLeftInset.NineSlice)
        SUI:Skin(LFDParentFrameInset)
        SUI:Skin(LFDParentFrameInset.NineSlice)
        SUI:Skin(RaidFinderFrameRoleInset)
        SUI:Skin(RaidFinderFrameRoleInset.NineSlice)
        SUI:Skin(RaidFinderFrameBottomInset)
        SUI:Skin(RaidFinderFrameBottomInset.NineSlice)
        SUI:Skin(LFGListFrame)
        SUI:Skin(LFGListFrame.CategorySelection)
        SUI:Skin(LFGListFrame.CategorySelection.Inset)
        SUI:Skin(LFGListFrame.CategorySelection.Inset.NineSlice)
        SUI:Skin(LFDRoleCheckPopup)
        SUI:Skin(LFDRoleCheckPopup.Border)
        SUI:Skin(PVPReadyDialog)
        SUI:Skin(PVPReadyDialog.Border)

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_PVPUI" then
                SUI:Skin(PlunderstormFrame.Inset)
                SUI:Skin(PlunderstormFrame.Inset.NineSlice)
            end
        end)

        SUI:Skin({
            LFDQueueFrameBackground,
            LFDParentFrameRoleBackground,
            PVEFrameTopFiligree,
            PVEFrameBottomFiligree,
            PVEFrameBlueBg,
        }, false, true)

        -- Tabs
        SUI:Skin(PVEFrameTab1)
        SUI:Skin(PVEFrameTab2)
        SUI:Skin(PVEFrameTab3)
        SUI:Skin(PVEFrameTab4)
    end
end
