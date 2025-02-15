local Module = SUI:NewModule("Skins.SpellBook");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            -- Professions
            if name == "Blizzard_ProfessionsBook" then
                SUI:Skin(ProfessionsBookFrame)
                SUI:Skin(ProfessionsBookFrame.NineSlice)
                SUI:Skin(ProfessionsBookFrameInset)
                SUI:Skin(ProfessionsBookFrameInset.NineSlice)
                SUI:Skin({
                    ProfessionsBookPage1,
                    ProfessionsBookPage2
                }, false, true)

                for i, v in pairs({
                    SecondaryProfession1Missing,
                    SecondaryProfession1.missingText,
                    SecondaryProfession2Missing,
                    SecondaryProfession2.missingText,
                    SecondaryProfession3Missing,
                    SecondaryProfession3.missingText,
                }) do
                    v:SetVertexColor(0.8, 0.8, 0.8)
                end
            end

            -- Spellbook
            if name == "Blizzard_PlayerSpells" then
                SUI:Skin(PlayerSpellsFrame)
                SUI:Skin(PlayerSpellsFrame.SpellBookFrame)
                SUI:Skin(PlayerSpellsFrame.NineSlice)

                -- Tabs
                SUI:Skin(PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[1])
                SUI:Skin(PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[2])
                PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.PagingControls.PageText:SetVertexColor(0.8, 0.8, 0.8)
                hooksecurefunc(SpellBookItemMixin, "UpdateVisuals", function(self)
                    self.Name:SetTextColor(0.8, 0.8, 0.8)
                    self.Button.Border:SetVertexColor(0.5, 0.5, 0.5)
                end)
            end
        end)
    end
end
