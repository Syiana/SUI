local Module = SUI:NewModule("Skins.Archaeology");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_ArchaeologyUI" then
        for i, v in pairs({ ArchaeologyFrame.NineSlice.TopEdge,
          ArchaeologyFrame.NineSlice.RightEdge,
          ArchaeologyFrame.NineSlice.BottomEdge,
          ArchaeologyFrame.NineSlice.LeftEdge,
          ArchaeologyFrame.NineSlice.TopRightCorner,
          ArchaeologyFrame.NineSlice.TopLeftCorner,
          ArchaeologyFrame.NineSlice.BottomLeftCorner,
          ArchaeologyFrame.NineSlice.BottomRightCorner, }) do
            v:SetVertexColor(.15, .15, .15)
        end
      end
    end)
  end
end