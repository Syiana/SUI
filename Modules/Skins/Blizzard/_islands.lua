local Module = SUI:NewModule("Skins.Islands");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_IslandsQueueUI" then
        for i, v in pairs({ IslandsQueueFrame.NineSlice.TopEdge,
          IslandsQueueFrame.NineSlice.RightEdge,
          IslandsQueueFrame.NineSlice.BottomEdge,
          IslandsQueueFrame.NineSlice.LeftEdge,
          IslandsQueueFrame.NineSlice.TopRightCorner,
          IslandsQueueFrame.NineSlice.TopLeftCorner,
          IslandsQueueFrame.NineSlice.BottomLeftCorner,
          IslandsQueueFrame.NineSlice.BottomRightCorner,
          IslandsQueueFrame.ArtOverlayFrame.PortraitFrame, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
          IslandsQueueFrame.Bg,
          IslandsQueueFrame.TitleBg }) do
            v:SetVertexColor(.3, .3, .3)
        end
      end
    end)
  end
end