local Module = SUI:NewModule("Skins.PvPUI");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_PVPUI" then
        for i, v in pairs({
          HonorFrame.BonusFrame.WorldBattlesTexture,
          ConquestFrame.RatedBGTexture, }) do
            v:SetVertexColor(.2, .2, .2)
        end
        for i, v in pairs({
          PVPQueueFrame.HonorInset.NineSlice.TopEdge,
          PVPQueueFrame.HonorInset.NineSlice.TopRightCorner,
          PVPQueueFrame.HonorInset.NineSlice.RightEdge,
          PVPQueueFrame.HonorInset.NineSlice.BottomRightCorner,
          PVPQueueFrame.HonorInset.NineSlice.BottomEdge,
          PVPQueueFrame.HonorInset.NineSlice.BottomLeftCorner,
          PVPQueueFrame.HonorInset.NineSlice.LeftEdge,
          PVPQueueFrame.HonorInset.NineSlice.TopLeftCorner,
          HonorFrame.Inset.NineSlice.TopEdge,
          HonorFrame.Inset.NineSlice.TopRightCorner,
          HonorFrame.Inset.NineSlice.RightEdge,
          HonorFrame.Inset.NineSlice.BottomRightCorner,
          HonorFrame.Inset.NineSlice.BottomEdge,
          HonorFrame.Inset.NineSlice.BottomLeftCorner,
          HonorFrame.Inset.NineSlice.LeftEdge,
          HonorFrame.Inset.NineSlice.TopLeftCorner,
          ConquestFrame.Inset.NineSlice.TopEdge,
          ConquestFrame.Inset.NineSlice.TopRightCorner,
          ConquestFrame.Inset.NineSlice.RightEdge,
          ConquestFrame.Inset.NineSlice.BottomRightCorner,
          ConquestFrame.Inset.NineSlice.BottomEdge,
          ConquestFrame.Inset.NineSlice.BottomLeftCorner,
          ConquestFrame.Inset.NineSlice.LeftEdge,
          ConquestFrame.Inset.NineSlice.TopLeftCorner,
          ConquestFrame.ConquestBar.Border,
          HonorFrame.ConquestBar.Border,}) do
            v:SetVertexColor(.3, .3, .3)
        end
        PVPQueueFrame.HonorInset:Hide();
      end
    end)
  end
end