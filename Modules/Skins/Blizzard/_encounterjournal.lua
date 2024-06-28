local Module = SUI:NewModule("Skins.EncounterJournal");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_EncounterJournal" then
                SUI:Skin(EncounterJournal)
                SUI:Skin(EncounterJournalInstanceSelect)
                SUI:Skin(EncounterJournalInset)
                SUI:Skin(EncounterJournalDungeonTab)
                SUI:Skin(EncounterJournalRaidTab)
                SUI:Skin(EncounterJournalNavBar)
                SUI:Skin(EncounterJournalSearchBox)
            end
        end)
    end
end
