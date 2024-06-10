local Module = SUI:NewModule("Skins.Collections");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_Collections" then
        for x, y in pairs(MountJournal.RightInset) do
          print(x)
        end
        for i, v in pairs({
          -- Collections Journal - General
          CollectionsJournalTopLeftCorner,
          CollectionsJournalTopRightCorner,
          CollectionsJournalPortraitFrame,
          CollectionsJournalTitleBg,
          CollectionsJournalTopBorder,
          CollectionsJournalTopTileStreaks,
          MountJournalInsetTopBorder,
          MountJournalInsetLeftBorder,
          MountJournalInsetRightBorder,
          CollectionsJournalBg,
          CollectionsJournalRightBorder,
          CollectionsJournalLeftBorder,
          CollectionsJournalBotRightCorner,
          CollectionsJournalBotLeftCorner,
          CollectionsJournalBottomBorder,

          -- Mount Journal
          MountJournalBg,
          MountJournal.RightInset.InsetBorderBottom,
          MountJournal.RightInset.InsetBorderRight,
          MountJournal.RightInset.InsetBorderBottomLeft,
          MountJournal.RightInset.InsetBorderBottomRight,
          MountJournal.RightInset.InsetBorderTop,
          MountJournal.RightInset.InsetBorderTopRight,
          MountJournal.RightInset.InsetBorderTopLeft,
          MountJournal.RightInset.InsetBorderLeft,
          MountJournalInsetBottomBorder,
          MountJournalMountButton_RightSeparator,
          MountJournalMountButton_LeftSeparator,
          MountJournalInsetTopRightCorner,
          MountJournalInsetTopLeftCorner,
          MountJournalInsetBotRightCorner,
          MountJournalInsetBotLeftCorner,
          MountJournal.ScrollBar.Background.Begin,
          MountJournal.ScrollBar.Background.Middle,
          MountJournal.ScrollBar.Background.End,

          -- Pet Journal
          PetJournalBg,
          PetJournal.RightInset.InsetBorderBottom,
          PetJournal.RightInset.InsetBorderRight,
          PetJournal.RightInset.InsetBorderBottomLeft,
          PetJournal.RightInset.InsetBorderBottomRight,
          PetJournal.RightInset.InsetBorderTop,
          PetJournal.RightInset.InsetBorderTopRight,
          PetJournal.RightInset.InsetBorderTopLeft,
          PetJournal.RightInset.InsetBorderLeft,
          PetJournalLeftInsetBg,
          PetJournalLeftInsetInsetTopBorder,
          PetJournalLeftInsetInsetLeftBorder,
          PetJournalLeftInsetInsetBottomBorder,
          PetJournalSummonButton_RightSeparator,
          PetJournalSummonButton_LeftSeparator,
          PetJournalLeftInsetInsetTopRightCorner,
          PetJournalLeftInsetInsetTopLeftCorner,
          PetJournalLeftInsetInsetBotRightCorner,
          PetJournalLeftInsetInsetBotLeftCorner,
          PetJournalLeftInsetInsetRightBorder,
          PetJournal.ScrollBar.Background.Begin,
          PetJournal.ScrollBar.Background.Middle,
          PetJournal.ScrollBar.Background.End,

          -- Toy Journal
          ToyBoxInsetTopBorder,
          ToyBoxInsetTopLeftCorner,
          ToyBoxInsetTopRightCorner,
          ToyBoxInsetLeftBorder,
          ToyBoxInsetRightBorder,
          ToyBoxInsetBottomBorder,
          ToyBoxInsetBotRightCorner,
          ToyBoxInsetBotLeftCorner,

          -- Heirlooms Journal
          HeirloomsJournalInsetTopBorder,
          HeirloomsJournalInsetTopLeftCorner,
          HeirloomsJournalInsetTopRightCorner,
          HeirloomsJournalInsetLeftBorder,
          HeirloomsJournalInsetRightBorder,
          HeirloomsJournalInsetBottomBorder,
          HeirloomsJournalInsetBotRightCorner,
          HeirloomsJournalInsetBotLeftCorner,

          -- Wardrobe Journal
          WardrobeCollectionFrameInsetTopBorder,
          WardrobeCollectionFrameInsetTopLeftCorner,
          WardrobeCollectionFrameInsetTopRightCorner,
          WardrobeCollectionFrameInsetLeftBorder,
          WardrobeCollectionFrameInsetRightBorder,
          WardrobeCollectionFrameInsetBottomBorder,
          WardrobeCollectionFrameInsetBotRightCorner,
          WardrobeCollectionFrameInsetBotLeftCorner,
        }) do
            v:SetVertexColor(.15, .15, .15)
        end
      end
    end)
  end
end