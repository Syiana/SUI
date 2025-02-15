local Module = SUI:NewModule("Skins.EncounterJournal");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_EncounterJournal" then
                SUI:Skin(EncounterJournal)
                SUI:Skin(EncounterJournal.NineSlice)
                SUI:Skin(EncounterJournalInset)
                SUI:Skin(EncounterJournalInset.NineSlice)
                SUI:Skin(EncounterJournalNavBar)
                SUI:Skin(EncounterJournalNavBar.overlay)

                -- Tabs
                SUI:Skin(EncounterJournalMonthlyActivitiesTab)
                SUI:Skin(EncounterJournalSuggestTab)
                SUI:Skin(EncounterJournalDungeonTab)
                SUI:Skin(EncounterJournalRaidTab)
                SUI:Skin(EncounterJournalLootJournalTab)
                --[[for i, v in pairs({
                    EncounterJournal.NineSlice.TopEdge,
                    EncounterJournal.NineSlice.RightEdge,
                    EncounterJournal.NineSlice.BottomEdge,
                    EncounterJournal.NineSlice.LeftEdge,
                    EncounterJournal.NineSlice.TopRightCorner,
                    EncounterJournal.NineSlice.TopLeftCorner,
                    EncounterJournal.NineSlice.BottomLeftCorner,
                    EncounterJournal.NineSlice.BottomRightCorner,
                    EncounterJournalInset.NineSlice.BottomEdge,
                    EncounterJournalInstanceSelectBG,
                    EncounterJournalNavBarInsetTopBorder,
                    EncounterJournalNavBarInsetLeftBorder,
                    EncounterJournalNavBarInsetBottomBorder,
                    EncounterJournalNavBarInsetRightBorder,
                    EncounterJournalMonthlyActivitiesTab.Left,
                    EncounterJournalMonthlyActivitiesTab.Middle,
                    EncounterJournalMonthlyActivitiesTab.Right,
                    EncounterJournalMonthlyActivitiesTab.LeftActive,
                    EncounterJournalMonthlyActivitiesTab.MiddleActive,
                    EncounterJournalMonthlyActivitiesTab.RightActive,
                    EncounterJournalMonthlyActivitiesTab.LeftHighlight,
                    EncounterJournalMonthlyActivitiesTab.MiddleHighlight,
                    EncounterJournalMonthlyActivitiesTab.RightHighlight,
                    EncounterJournalSuggestTab.Left,
                    EncounterJournalSuggestTab.Middle,
                    EncounterJournalSuggestTab.Right,
                    EncounterJournalSuggestTab.LeftActive,
                    EncounterJournalSuggestTab.MiddleActive,
                    EncounterJournalSuggestTab.RightActive,
                    EncounterJournalSuggestTab.LeftHighlight,
                    EncounterJournalSuggestTab.MiddleHighlight,
                    EncounterJournalSuggestTab.RightHighlight,
                    EncounterJournalDungeonTab.Left,
                    EncounterJournalDungeonTab.Middle,
                    EncounterJournalDungeonTab.Right,
                    EncounterJournalDungeonTab.LeftActive,
                    EncounterJournalDungeonTab.MiddleActive,
                    EncounterJournalDungeonTab.RightActive,
                    EncounterJournalDungeonTab.LeftHighlight,
                    EncounterJournalDungeonTab.MiddleHighlight,
                    EncounterJournalDungeonTab.RightHighlight,
                    EncounterJournalRaidTab.Left,
                    EncounterJournalRaidTab.Middle,
                    EncounterJournalRaidTab.Right,
                    EncounterJournalRaidTab.LeftActive,
                    EncounterJournalRaidTab.MiddleActive,
                    EncounterJournalRaidTab.RightActive,
                    EncounterJournalRaidTab.LeftHighlight,
                    EncounterJournalRaidTab.MiddleHighlight,
                    EncounterJournalRaidTab.RightHighlight,
                    EncounterJournalLootJournalTab.Left,
                    EncounterJournalLootJournalTab.Middle,
                    EncounterJournalLootJournalTab.Right,
                    EncounterJournalLootJournalTab.LeftActive,
                    EncounterJournalLootJournalTab.MiddleActive,
                    EncounterJournalLootJournalTab.RightActive,
                    EncounterJournalLootJournalTab.LeftHighlight,
                    EncounterJournalLootJournalTab.MiddleHighlight,
                    EncounterJournalLootJournalTab.RightHighlight,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end]]
                EncounterJournalInset:SetAlpha(0)
            end
        end)
    end
end
