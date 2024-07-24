local Module = SUI:NewModule("Skins.Talents");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_PlayerSpells" then
                for i, v in pairs({
                    PlayerSpellsFrame.TalentsFrame.BottomBar,
                    PlayerSpellsFrame.TalentsFrame.OverlayBackgroundMidMask,
                    PlayerSpellsFrame.TalentsFrame.OverlayBackgroundRightMask,
                    PlayerSpellsFrame.TalentsFrame.LoadSystem.Dropdown.Background,
                    PlayerSpellsFrame.TalentsFrame.LoadSystem.Dropdown.Arrow,
                    PlayerSpellsFrame.TalentsFrame.SearchBox.Left,
                    PlayerSpellsFrame.TalentsFrame.SearchBox.Middle,
                    PlayerSpellsFrame.TalentsFrame.SearchBox.Right,
                    PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer.Background,
                    PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer.DefaultResultButton.HighlightTexture,
                    PlayerSpellsFrame.TalentsFrame.ApplyButton.Left,
                    PlayerSpellsFrame.TalentsFrame.ApplyButton.Middle,
                    PlayerSpellsFrame.TalentsFrame.ApplyButton.Right,
                    PlayerSpellsFrame.TabSystem.tabs[1].Left,
                    PlayerSpellsFrame.TabSystem.tabs[1].Middle,
                    PlayerSpellsFrame.TabSystem.tabs[1].Right,
                    PlayerSpellsFrame.TabSystem.tabs[1].LeftActive,
                    PlayerSpellsFrame.TabSystem.tabs[1].MiddleActive,
                    PlayerSpellsFrame.TabSystem.tabs[1].RightActive,
                    PlayerSpellsFrame.TabSystem.tabs[1].LeftHighlight,
                    PlayerSpellsFrame.TabSystem.tabs[1].MiddleHighlight,
                    PlayerSpellsFrame.TabSystem.tabs[1].RightHighlight,
                    PlayerSpellsFrame.TabSystem.tabs[2].Left,
                    PlayerSpellsFrame.TabSystem.tabs[2].Middle,
                    PlayerSpellsFrame.TabSystem.tabs[2].Right,
                    PlayerSpellsFrame.TabSystem.tabs[2].LeftActive,
                    PlayerSpellsFrame.TabSystem.tabs[2].MiddleActive,
                    PlayerSpellsFrame.TabSystem.tabs[2].RightActive,
                    PlayerSpellsFrame.TabSystem.tabs[2].LeftHighlight,
                    PlayerSpellsFrame.TabSystem.tabs[2].MiddleHighlight,
                    PlayerSpellsFrame.TabSystem.tabs[2].RightHighlight,
                    PlayerSpellsFrame.TabSystem.tabs[3].Left,
                    PlayerSpellsFrame.TabSystem.tabs[3].Middle,
                    PlayerSpellsFrame.TabSystem.tabs[3].Right,
                    PlayerSpellsFrame.TabSystem.tabs[3].LeftActive,
                    PlayerSpellsFrame.TabSystem.tabs[3].MiddleActive,
                    PlayerSpellsFrame.TabSystem.tabs[3].RightActive,
                    PlayerSpellsFrame.TabSystem.tabs[3].LeftHighlight,
                    PlayerSpellsFrame.TabSystem.tabs[3].MiddleHighlight,
                    PlayerSpellsFrame.TabSystem.tabs[3].RightHighlight,
                    HeroTalentsSelectionDialog.NineSlice.Center,
                    HeroTalentsSelectionDialog.NineSlice.TopRightCorner,
                    HeroTalentsSelectionDialog.NineSlice.TopLeftCorner,
                    HeroTalentsSelectionDialog.NineSlice.RightEdge,
                    HeroTalentsSelectionDialog.NineSlice.TopEdge,
                    HeroTalentsSelectionDialog.NineSlice.BottomEdge,
                    HeroTalentsSelectionDialog.NineSlice.BottomLeftCorner,
                    HeroTalentsSelectionDialog.NineSlice.BottomRightCorner,
                    HeroTalentsSelectionDialog.NineSlice.LeftEdge
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
                for i, v in pairs({
                    PVEFrameTopFiligree,
                    PVEFrameBottomFiligree,
                    PVEFrameBlueBg,
                    LFGListFrame.CategorySelection.Inset.CustomBG
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
                for i, v in pairs({
                    ClassTalentFrameTitleBg,
                    ClassTalentFrameBg,
                    ClassTalentFrameTalentsPvpTalentFrameTalentListBg
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
        end)
    end
end
