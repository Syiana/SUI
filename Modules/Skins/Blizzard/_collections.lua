local Module = SUI:NewModule("Skins.Collections");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Collections" then
                -- Collections Frame
                SUI:Skin(CollectionsJournal, true)
                SUI:Skin(CollectionsJournal.NineSlice, true)

                -- Mount Journal
                SUI:Skin(MountJournal, true)
                SUI:Skin(MountJournal.MountDisplay, true)
                SUI:Skin(MountJournal.LeftInset.NineSlice, true)
                SUI:Skin(MountJournal.BottomLeftInset, true)
                SUI:Skin(MountJournal.BottomLeftInset.NineSlice, true)
                SUI:Skin(MountJournal.RightInset.NineSlice, true)
                SUI:Skin(MountJournal.BottomLeftInset.SlotButton, true)
                select(2, MountJournal.BottomLeftInset.SlotButton:GetRegions()):SetVertexColor(1, 1, 1)

                -- ToyBox
                SUI:Skin(ToyBox, true)
                SUI:Skin(ToyBox.iconsFrame, true)
                SUI:Skin(ToyBox.iconsFrame.NineSlice, true)

                -- Heirlooms Journal
                SUI:Skin(HeirloomsJournal, true)
                SUI:Skin(HeirloomsJournal.iconsFrame, true)
                SUI:Skin(HeirloomsJournal.iconsFrame.NineSlice, true)

                -- Pet Journal
                SUI:Skin(PetJournalLeftInset, true)
                SUI:Skin(PetJournalLeftInset.NineSlice, true)
                SUI:Skin(PetJournalPetCardInset, true)
                SUI:Skin(PetJournalPetCardInset.NineSlice, true)
                SUI:Skin(PetJournalPetCard, true)
                SUI:Skin(PetJournalLoadoutPet1, true)
                SUI:Skin(PetJournalLoadoutPet2, true)
                SUI:Skin(PetJournalLoadoutPet3, true)
                SUI:Skin(PetJournalLoadoutBorder, true)
                SUI:Skin(PetJournalRightInset.NineSlice, true)

                -- Wardrobe
                SUI:Skin(WardrobeCollectionFrame.ItemsCollectionFrame, true)

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
                }, true, true)

                -- Tabs
                SUI:Skin(CollectionsJournalTab1, true)
                SUI:Skin(CollectionsJournalTab2, true)
                SUI:Skin(CollectionsJournalTab3, true)
                SUI:Skin(CollectionsJournalTab4, true)
                SUI:Skin(CollectionsJournalTab5, true)
                SUI:Skin(WardrobeCollectionFrameTab1, true)
                SUI:Skin(WardrobeCollectionFrameTab2, true)
            end
        end)
    end
end
