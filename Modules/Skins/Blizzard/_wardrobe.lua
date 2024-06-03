local Module = SUI:NewModule("Skins.Wardrobe");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_Collections" or name == "Blizzard_Wardrobe" then
        for i, v in pairs({
          WardrobeFrame.NineSlice.TopEdge,
          WardrobeFrame.NineSlice.RightEdge,
          WardrobeFrame.NineSlice.BottomEdge,
          WardrobeFrame.NineSlice.LeftEdge,
          WardrobeFrame.NineSlice.TopRightCorner,
          WardrobeFrame.NineSlice.TopLeftCorner,
          WardrobeFrame.NineSlice.BottomLeftCorner,
          WardrobeFrame.NineSlice.BottomRightCorner, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
          WardrobeFrame.Bg,
          WardrobeFrame.TitleBg }) do
            v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.TopEdge,
          WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.RightEdge,
          WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.BottomEdge,
          WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.LeftEdge,
          WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.TopRightCorner,
          WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.TopLeftCorner,
          WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.BottomLeftCorner,
          WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.BottomRightCorner,
          WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.TopEdge,
          WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.RightEdge,
          WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.BottomEdge,
          WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.LeftEdge,
          WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.TopRightCorner,
          WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.TopLeftCorner,
          WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.BottomLeftCorner,
          WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.BottomRightCorner,
          WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.TopEdge,
          WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.RightEdge,
          WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.BottomEdge,
          WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.LeftEdge,
          WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.TopRightCorner,
          WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.TopLeftCorner,
          WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.BottomLeftCorner,
          WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.BottomRightCorner }) do
            v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          WardrobeCollectionFrameScrollFrameScrollBarBottom,
          WardrobeCollectionFrameScrollFrameScrollBarMiddle,
          WardrobeCollectionFrameScrollFrameScrollBarTop,
          WardrobeCollectionFrameScrollFrameScrollBarThumbTexture,
          WardrobeCollectionFrameScrollFrameScrollBarScrollUpButton.Normal,
          WardrobeCollectionFrameScrollFrameScrollBarScrollDownButton.Normal,
          WardrobeCollectionFrameScrollFrameScrollBarScrollUpButton.Disabled,
          WardrobeCollectionFrameScrollFrameScrollBarScrollDownButton.Disabled, }) do
          v:SetVertexColor(.4, .4, .4)
        end
      end
    end)
  end
end