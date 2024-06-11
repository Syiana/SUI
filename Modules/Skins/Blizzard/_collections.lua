local Module = SUI:NewModule("Skins.Collections");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Collections" then
                -- Collections Journal
                SUI:Skin(CollectionsJournal)
                SUI:Skin(CollectionsJournalTab1)
                SUI:Skin(CollectionsJournalTab2)
                SUI:Skin(CollectionsJournalTab3)
                SUI:Skin(CollectionsJournalTab4)
                SUI:Skin(CollectionsJournalTab5)

                -- Mount Journal
                SUI:Skin(MountJournal)
                SUI:Skin(MountJournal.RightInset)
                SUI:Skin(MountJournal.LeftInset)
                SUI:Skin(MountJournal.ScrollBar)
                SUI:Skin(MountJournal.ScrollBar.Background)
                SUI:Skin(MountJournalMountButton)

                -- Pet Journal
                SUI:Skin(PetJournal)
                SUI:Skin(PetJournal.RightInset)
                SUI:Skin(PetJournal.LeftInset)
                SUI:Skin(PetJournal.ScrollBar)
                SUI:Skin(PetJournal.ScrollBar.Background)
                SUI:Skin(PetJournalSummonButton)

                -- Toy Box
                SUI:Skin(ToyBox)

                -- Heirlooms Journal
                SUI:Skin(HeirloomsJournal)

                -- Wardrobe Journal
                SUI:Skin(WardrobeCollectionFrame)
            end
        end)
    end
end
