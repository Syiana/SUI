local Module = SUI:NewModule("Skins.EncounterJournal");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_EncounterJournal" then
                SUI:Skin(EncounterJournal, true)
                SUI:Skin(EncounterJournal.NineSlice, true)
                SUI:Skin(EncounterJournalInset, true)
                SUI:Skin(EncounterJournalInset.NineSlice, true)
                SUI:Skin(EncounterJournalNavBar, true)
                SUI:Skin(EncounterJournalNavBar.overlay, true)

                -- Tabs
                SUI:Skin(EncounterJournalMonthlyActivitiesTab, true)
                SUI:Skin(EncounterJournalSuggestTab, true)
                SUI:Skin(EncounterJournalDungeonTab, true)
                SUI:Skin(EncounterJournalRaidTab, true)
                SUI:Skin(EncounterJournalLootJournalTab, true)
                EncounterJournalInset:SetAlpha(0)
            end
        end)
    end
end
