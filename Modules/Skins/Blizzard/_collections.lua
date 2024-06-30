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
                SUI:Skin(MountJournalFilterButton)
                SUI:Skin(MountJournalSearchBox)
                SUI:Skin(MountJournal.MountCount)

                -- Pet Journal
                SUI:Skin(PetJournal)
                SUI:Skin(PetJournal.RightInset)
                SUI:Skin(PetJournal.LeftInset)
                SUI:Skin(PetJournal.ScrollBar)
                SUI:Skin(PetJournal.ScrollBar.Background)
                SUI:Skin(PetJournalSummonButton)
                SUI:Skin(PetJournalFilterButton)
                SUI:Skin(PetJournalSearchBox)
                SUI:Skin(PetJournal.PetCount)

                -- Toy Box
                SUI:Skin(ToyBox)
                SUI:Skin(ToyBox.iconsFrame)
                SUI:Skin(ToyBox.searchBox)
                SUI:Skin(ToyBoxFilterButton)
                SUI:Skin({ToyBox.progressBar.border}, false, true)

                -- Heirlooms Journal
                SUI:Skin(HeirloomsJournal)
                SUI:Skin(HeirloomsJournal.iconsFrame)
                SUI:Skin(HeirloomsJournalClassDropDown)
                SUI:Skin(HeirloomsJournalSearchBox)
                SUI:Skin(HeirloomsJournal.FilterButton)
                SUI:Skin({HeirloomsJournal.progressBar.border}, false, true)

                -- Wardrobe Journal
                SUI:Skin(WardrobeCollectionFrame)
                SUI:Skin(WardrobeCollectionFrame.ItemsCollectionFrame)
                SUI:Skin(WardrobeCollectionFrameWeaponDropDown)
                SUI:Skin({WardrobeCollectionFrame.progressBar.border}, false, true)
                SUI:Skin(WardrobeCollectionFrameSearchBox)
                SUI:Skin(WardrobeCollectionFrame.FilterButton)

                -- Buttons
                SUI:Skin({
                    MountJournalMountButton.Left,
                    MountJournalMountButton.Middle,
                    MountJournalMountButton.Right,
                    PetJournalSummonButton.Left,
                    PetJournalSummonButton.Middle,
                    PetJournalSummonButton.Right
                }, false, true, false, true)
            end
        end)
    end
end