local Module = SUI:NewModule("Skins.Loot");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({ LootFrame.NineSlice.TopEdge,
    LootFrame.NineSlice.RightEdge,
    LootFrame.NineSlice.BottomEdge,
    LootFrame.NineSlice.LeftEdge,
    LootFrame.NineSlice.TopRightCorner,
    LootFrame.NineSlice.TopLeftCorner,
    LootFrame.NineSlice.BottomLeftCorner,
    LootFrame.NineSlice.BottomRightCorner, }) do
      v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({ LootFrame.NineSlice.TopEdge,
      LootFrameInset.NineSlice.RightEdge,
      LootFrameInset.NineSlice.BottomEdge,
      LootFrameInset.NineSlice.LeftEdge,
      LootFrameInset.NineSlice.TopRightCorner,
      LootFrameInset.NineSlice.TopLeftCorner,
      LootFrameInset.NineSlice.BottomLeftCorner,
      LootFrameInset.NineSlice.BottomRightCorner, }) do
        v:SetVertexColor(.3, .3, .3)
    end
    for i, v in pairs({
      LootFrame.Bg,
      LootFrame.TitleBg,
      LootFrameInset.Bg }) do
        v:SetVertexColor(.3, .3, .3)
    end
  end
end