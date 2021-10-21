local Module = SUI:NewModule("Skins.Alliedraces");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_AlliedRacesUI" then
        for i, v in pairs({ AlliedRacesFrame.NineSlice.TopEdge,
          AlliedRacesFrame.NineSlice.RightEdge,
          AlliedRacesFrame.NineSlice.BottomEdge,
          AlliedRacesFrame.NineSlice.LeftEdge,
          AlliedRacesFrame.NineSlice.TopRightCorner,
          AlliedRacesFrame.NineSlice.TopLeftCorner,
          AlliedRacesFrame.NineSlice.BottomLeftCorner,
          AlliedRacesFrame.NineSlice.BottomRightCorner,
          AlliedRacesFrameInset.NineSlice.BottomEdge, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
          AlliedRacesFrame.Bg,
          AlliedRacesFrame.TitleBg }) do
            v:SetVertexColor(.3, .3, .3)
        end
      end
    end)
  end
end