local Module = SUI:NewModule("Skins.Collections");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Collections" then
                -- Collections Frame
                SUI:Skin(CollectionsJournal)
                SUI:Skin(CollectionsJournal.NineSlice)

                -- Mount Journal
                SUI:Skin(MountJournal)
                SUI:Skin(MountJournal.MountDisplay)
                SUI:Skin(MountJournal.LeftInset.NineSlice)
                SUI:Skin(MountJournal.BottomLeftInset)
                SUI:Skin(MountJournal.BottomLeftInset.NineSlice)
                SUI:Skin(MountJournal.RightInset.NineSlice)

                -- ToyBox
                SUI:Skin(ToyBox)
                SUI:Skin(ToyBox.iconsFrame)
                SUI:Skin(ToyBox.iconsFrame.NineSlice)

                -- Heirlooms Journal
                SUI:Skin(HeirloomsJournal)
                SUI:Skin(HeirloomsJournal.iconsFrame)
                SUI:Skin(HeirloomsJournal.iconsFrame.NineSlice)

                -- Pet Journal
                SUI:Skin(PetJournalLeftInset)
                SUI:Skin(PetJournalLeftInset.NineSlice)
                SUI:Skin(PetJournalPetCardInset)
                SUI:Skin(PetJournalPetCardInset.NineSlice)
                SUI:Skin(PetJournalPetCard)
                SUI:Skin(PetJournalLoadoutPet1)
                SUI:Skin(PetJournalLoadoutPet2)
                SUI:Skin(PetJournalLoadoutPet3)
                SUI:Skin(PetJournalLoadoutBorder)
                SUI:Skin(PetJournalRightInset.NineSlice)

                -- Wardrobe
                SUI:Skin(WardrobeCollectionFrame.ItemsCollectionFrame)

                -- Specific Frames
                SUI:Skin({
                    CollectionsJournalBg,
                    MountJournalListScrollFrameScrollBarThumbTexture,
                    MountJournalListScrollFrameScrollBarTop,
                    MountJournalListScrollFrameScrollBarMiddle,
                    MountJournalListScrollFrameScrollBarBottom,
                    PetJournalListScrollFrameScrollBarThumbTexture,
                    PetJournalListScrollFrameScrollBarTop,
                    PetJournalListScrollFrameScrollBarMiddle,
                    PetJournalListScrollFrameScrollBarBottom
                }, false, true)

                -- Tabs
                SUI:Skin(CollectionsJournalTab1)
                SUI:Skin(CollectionsJournalTab2)
                SUI:Skin(CollectionsJournalTab3)
                SUI:Skin(CollectionsJournalTab4)
                SUI:Skin(CollectionsJournalTab5)
                SUI:Skin(WardrobeCollectionFrameTab1)
                SUI:Skin(WardrobeCollectionFrameTab2)
            end
        end)
    end
end
