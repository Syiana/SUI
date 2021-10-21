local Module = SUI:NewModule("Skins.Collections");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_Collections" then
        for i, v in pairs({
          CollectionsJournal.NineSlice.TopEdge,
          CollectionsJournal.NineSlice.TopRightCorner,
          CollectionsJournal.NineSlice.RightEdge,
          CollectionsJournal.NineSlice.BottomRightCorner,
          CollectionsJournal.NineSlice.BottomEdge,
          CollectionsJournal.NineSlice.BottomLeftCorner,
          CollectionsJournal.NineSlice.LeftEdge,
          CollectionsJournal.NineSlice.TopLeftCorner}) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
          CollectionsJournal.Bg,
          CollectionsJournal.TitleBg }) do
            v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          MountJournal.LeftInset.NineSlice.TopEdge,
          MountJournal.LeftInset.NineSlice.TopRightCorner,
          MountJournal.LeftInset.NineSlice.TopLeftCorner,
          MountJournal.LeftInset.NineSlice.RightEdge,
          MountJournal.LeftInset.NineSlice.BottomRightCorner,
          MountJournal.LeftInset.NineSlice.BottomEdge,
          MountJournal.LeftInset.NineSlice.BottomLeftCorner,
          MountJournal.LeftInset.NineSlice.LeftEdge,
          MountJournal.BottomLeftInset.NineSlice.TopEdge,
          MountJournal.BottomLeftInset.NineSlice.TopRightCorner,
          MountJournal.BottomLeftInset.NineSlice.TopLeftCorner,
          MountJournal.BottomLeftInset.NineSlice.RightEdge,
          MountJournal.BottomLeftInset.NineSlice.BottomRightCorner,
          MountJournal.BottomLeftInset.NineSlice.BottomEdge,
          MountJournal.BottomLeftInset.NineSlice.BottomLeftCorner,
          MountJournal.BottomLeftInset.NineSlice.LeftEdge,
          MountJournal.RightInset.NineSlice.TopEdge,
          MountJournal.RightInset.NineSlice.TopRightCorner,
          MountJournal.RightInset.NineSlice.TopLeftCorner,
          MountJournal.RightInset.NineSlice.RightEdge,
          MountJournal.RightInset.NineSlice.BottomRightCorner,
          MountJournal.RightInset.NineSlice.BottomEdge,
          MountJournal.RightInset.NineSlice.BottomLeftCorner,
          MountJournal.RightInset.NineSlice.LeftEdge,
          ToyBox.iconsFrame.NineSlice.TopEdge,
          ToyBox.iconsFrame.NineSlice.RightEdge,
          ToyBox.iconsFrame.NineSlice.BottomEdge,
          ToyBox.iconsFrame.NineSlice.LeftEdge,
          ToyBox.iconsFrame.NineSlice.TopRightCorner,
          ToyBox.iconsFrame.NineSlice.TopLeftCorner,
          ToyBox.iconsFrame.NineSlice.BottomLeftCorner,
          ToyBox.iconsFrame.NineSlice.BottomRightCorner,
          ToyBox.iconsFrame.NineSlice.BottomEdge,
          HeirloomsJournal.iconsFrame.NineSlice.TopEdge,
          HeirloomsJournal.iconsFrame.NineSlice.RightEdge,
          HeirloomsJournal.iconsFrame.NineSlice.BottomEdge,
          HeirloomsJournal.iconsFrame.NineSlice.LeftEdge,
          HeirloomsJournal.iconsFrame.NineSlice.TopRightCorner,
          HeirloomsJournal.iconsFrame.NineSlice.TopLeftCorner,
          HeirloomsJournal.iconsFrame.NineSlice.BottomLeftCorner,
          HeirloomsJournal.iconsFrame.NineSlice.BottomRightCorner,
          HeirloomsJournal.iconsFrame.NineSlice.BottomEdge,
          PetJournalLeftInset.NineSlice.TopEdge,
          PetJournalLeftInset.NineSlice.RightEdge,
          PetJournalLeftInset.NineSlice.BottomEdge,
          PetJournalLeftInset.NineSlice.LeftEdge,
          PetJournalLeftInset.NineSlice.TopRightCorner,
          PetJournalLeftInset.NineSlice.TopLeftCorner,
          PetJournalLeftInset.NineSlice.BottomLeftCorner,
          PetJournalLeftInset.NineSlice.BottomRightCorner,
          PetJournalLeftInset.NineSlice.BottomEdge,
          PetJournalPetCardInset.NineSlice.TopEdge,
          PetJournalPetCardInset.NineSlice.RightEdge,
          PetJournalPetCardInset.NineSlice.BottomEdge,
          PetJournalPetCardInset.NineSlice.LeftEdge,
          PetJournalPetCardInset.NineSlice.TopRightCorner,
          PetJournalPetCardInset.NineSlice.TopLeftCorner,
          PetJournalPetCardInset.NineSlice.BottomLeftCorner,
          PetJournalPetCardInset.NineSlice.BottomRightCorner,
          PetJournalPetCardInset.NineSlice.BottomEdge, }) do
            v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          MountJournalListScrollFrameScrollBarThumbTexture,
          MountJournalListScrollFrameScrollBarTop,
          MountJournalListScrollFrameScrollBarMiddle,
          MountJournalListScrollFrameScrollBarBottom,
          MountJournalListScrollFrameScrollBarScrollUpButton.Normal,
          MountJournalListScrollFrameScrollBarScrollDownButton.Normal,
          MountJournalListScrollFrameScrollBarScrollUpButton.Disabled,
          MountJournalListScrollFrameScrollBarScrollDownButton.Disabled,
          PetJournalListScrollFrameScrollBarThumbTexture,
          PetJournalListScrollFrameScrollBarTop,
          PetJournalListScrollFrameScrollBarMiddle,
          PetJournalListScrollFrameScrollBarBottom,
          PetJournalListScrollFrameScrollBarScrollUpButton.Normal,
          PetJournalListScrollFrameScrollBarScrollDownButton.Normal,
          PetJournalListScrollFrameScrollBarScrollUpButton.Disabled,
          PetJournalListScrollFrameScrollBarScrollDownButton.Disabled, }) do
          v:SetVertexColor(.4, .4, .4)
        end
      end
    end)
  end
end