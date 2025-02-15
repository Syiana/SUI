local Module = SUI:NewModule("Skins.Talents");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_PlayerSpells" then
                SUI:Skin(PlayerSpellsFrame)
                SUI:Skin(PlayerSpellsFrame.TalentsFrame)
                SUI:Skin(PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer)
                SUI:Skin(PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer.DefaultResultButton)
                SUI:Skin(PlayerSpellsFrame.TalentsFrame.SearchBox)
                SUI:Skin(PlayerSpellsFrame.TalentsFrame.LoadSystem)
                SUI:Skin(PlayerSpellsFrame.TalentsFrame.LoadSystem.Dropdown)
                SUI:Skin(HeroTalentsSelectionDialog)
                SUI:Skin(HeroTalentsSelectionDialog.NineSlice)
                SUI:Skin({
                    ClassTalentFrameTitleBg,
                    ClassTalentFrameBg,
                    ClassTalentFrameTalentsPvpTalentFrameTalentListBg
                }, false, true)

                -- Tabs
                SUI:Skin(PlayerSpellsFrame.TalentsFrame.ApplyButton)
                SUI:Skin(PlayerSpellsFrame.TabSystem.tabs[1])
                SUI:Skin(PlayerSpellsFrame.TabSystem.tabs[2])
                SUI:Skin(PlayerSpellsFrame.TabSystem.tabs[3])

                -- Reset Background
                select(4, PlayerSpellsFrame.TalentsFrame:GetRegions()):SetVertexColor(1, 1, 1, 0.7)
            end
        end)
    end
end
