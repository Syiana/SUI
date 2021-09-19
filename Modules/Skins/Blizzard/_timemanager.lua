local Module = SUI:NewModule("Skins.Bags");

function Module:OnEnable()
  local f = CreateFrame("Frame")
  f:RegisterEvent("ADDON_LOADED")
  f:SetScript("OnEvent", function(self, event, name)
    if name == "Blizzard_TimeManager" then
      for i, v in pairs({ TimeManagerFrame.NineSlice.TopEdge,
        TimeManagerFrame.NineSlice.RightEdge,
        TimeManagerFrame.NineSlice.BottomEdge,
        TimeManagerFrame.NineSlice.LeftEdge,
        TimeManagerFrame.NineSlice.TopRightCorner,
        TimeManagerFrame.NineSlice.TopLeftCorner,
        TimeManagerFrame.NineSlice.BottomLeftCorner,
        TimeManagerFrame.NineSlice.BottomRightCorner,
        TimeManagerFrameInset.NineSlice.TopEdge,
        TimeManagerFrameInset.NineSlice.RightEdge,
        TimeManagerFrameInset.NineSlice.BottomEdge,
        TimeManagerFrameInset.NineSlice.LeftEdge,
        TimeManagerFrameInset.NineSlice.TopRightCorner,
        TimeManagerFrameInset.NineSlice.TopLeftCorner,
        StopwatchFrameBackgroundLeft, }) do
          v:SetVertexColor(.15, .15, .15)
      end
    end
  end)

end