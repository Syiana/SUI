local Module = SUI:NewModule("Skins.SpellBook");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            -- Professions
            if name == "Blizzard_ProfessionsBook" then
                for i, v in pairs({
                    ProfessionsBookFrame.NineSlice.BottomEdge,
                    ProfessionsBookFrame.NineSlice.BottomLeftCorner,
                    ProfessionsBookFrame.NineSlice.BottomRightCorner,
                    ProfessionsBookFrame.NineSlice.Center,
                    ProfessionsBookFrame.NineSlice.LeftEdge,
                    ProfessionsBookFrame.NineSlice.RightEdge,
                    ProfessionsBookFrame.NineSlice.TopEdge,
                    ProfessionsBookFrame.NineSlice.TopLeftCorner,
                    ProfessionsBookFrame.NineSlice.TopRightCorner,
                    ProfessionsBookPage1,
                    ProfessionsBookPage2
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end

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
                for i, v in pairs({
                    PlayerSpellsFrame.SpellBookFrame.TopBar,
                    PlayerSpellsFrame.NineSlice.TopEdge,
                    PlayerSpellsFrame.NineSlice.RightEdge,
                    PlayerSpellsFrame.NineSlice.LeftEdge,
                    PlayerSpellsFrame.NineSlice.TopEdge,
                    PlayerSpellsFrame.NineSlice.BottomEdge,
                    PlayerSpellsFrame.NineSlice.PortraitFrame,
                    PlayerSpellsFrame.NineSlice.TopRightCorner,
                    PlayerSpellsFrame.NineSlice.TopLeftCorner,
                    PlayerSpellsFrame.NineSlice.BottomLeftCorner,
                    PlayerSpellsFrame.NineSlice.BottomRightCorner,
                    PlayerSpellsFrame.NineSlice.BottomEdge,
                    PlayerSpellsFrame.SpellBookFrame.BookBGLeft,
                    PlayerSpellsFrame.SpellBookFrame.BookBGRight,
                    PlayerSpellsFrame.SpellBookFrame.BookCornerFlipbook,
                    PlayerSpellsFrame.SpellBookFrame.BookBGHalved,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[1].Left,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[1].Middle,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[1].Right,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[1].LeftActive,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[1].MiddleActive,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[1].RightActive,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[1].LeftHighlight,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[1].MiddleHighlight,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[1].RightHighlight,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[2].Left,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[2].Middle,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[2].Right,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[2].LeftActive,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[2].MiddleActive,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[2].RightActive,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[2].LeftHighlight,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[2].MiddleHighlight,
                    PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[2].RightHighlight,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
                PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.PagingControls.PageText:SetVertexColor(0.8, 0.8, 0.8)
                hooksecurefunc(SpellBookItemMixin, "UpdateVisuals", function(self)
                    self.Name:SetTextColor(0.8, 0.8, 0.8)
                    self.Button.Border:SetVertexColor(0.5, 0.5, 0.5)
                end)
            end
        end)
    end
end
