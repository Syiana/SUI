local Module = SUI:NewModule("Skins.Talents");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_PlayerSpells" then
                SUI:Skin(PlayerSpellsFrame, true)
                SUI:Skin(PlayerSpellsFrame.TalentsFrame, true)
                SUI:Skin(PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer, true)
                SUI:Skin(PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer.DefaultResultButton, true)
                SUI:Skin(PlayerSpellsFrame.TalentsFrame.SearchBox, true)
                SUI:Skin(PlayerSpellsFrame.TalentsFrame.LoadSystem, true)
                SUI:Skin(PlayerSpellsFrame.TalentsFrame.LoadSystem.Dropdown, true)
                SUI:Skin(HeroTalentsSelectionDialog, true)
                SUI:Skin(HeroTalentsSelectionDialog.NineSlice, true)
                SUI:Skin({
                    ClassTalentFrameTitleBg,
                    ClassTalentFrameBg,
                    ClassTalentFrameTalentsPvpTalentFrameTalentListBg
                }, true, true)

                -- Tabs
                SUI:Skin(PlayerSpellsFrame.TalentsFrame.ApplyButton, true)
                SUI:Skin(PlayerSpellsFrame.TabSystem.tabs[1], true)
                SUI:Skin(PlayerSpellsFrame.TabSystem.tabs[2], true)
                SUI:Skin(PlayerSpellsFrame.TabSystem.tabs[3], true)

                -- Reset Background
                select(4, PlayerSpellsFrame.TalentsFrame:GetRegions()):SetVertexColor(1, 1, 1, 0.7)
                select(4, PlayerSpellsFrame.TalentsFrame:GetRegions()):SetDesaturated(false)
            end
        end)
    end
end
