local Module = SUI:NewModule("Skins.Bags");

function Module:OnEnable()

  local nineSlice = {
    "BottomEdge", "BottomLeftCorner", "BottomRightCorner", "Center", "LeftEdge", "RightEdge", "TopEdge", "TopLeftCorner", "TopRightCorner"
  }
  local bg = {
    "BottomEdge", "BottomLeft", "BottomRight", "TopSection"
  }

  if (SUI:Color()) then
    for i = 1, 5 do
      local container = _G["ContainerFrame" .. i]

      container.Background1Slot:SetVertexColor(unpack(SUI:Color(0.1)))
      container.NineSlice:SetVertexColor(unpack(SUI:Color(0.1)))

      for _, ns in pairs(nineSlice) do
        container.NineSlice[ns]:SetVertexColor(unpack(SUI:Color(0.1)))
      end

      for _, b in pairs(bg) do
        container.Bg[b]:SetVertexColor(unpack(SUI:Color(0.1)))
      end
    end
    --BackpackTokenFrame:GetRegions():SetVertexColor(unpack(SUI:Color(0.1)))
  end
end