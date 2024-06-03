local Module = SUI:NewModule("Skins.Loot");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({ 
      LootFrameTopEdge,
      LootFrameRightEdge,
      LootFrameBottomEdge,
      LootFrameLeftEdge,
      LootFrameTopRightCorner,
      LootFrameTopLeftCorner,
      LootFrameBottomLeftCorner,
      LootFrameBottomRightCorner,
    }) do
    v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      LootFrameTopEdge,
      LootFrameInsetRightEdge,
      LootFrameInsetBottomEdge,
      LootFrameInsetLeftEdge,
      LootFrameInsetTopRightCorner,
      LootFrameInsetTopLeftCorner,
      LootFrameInsetBottomLeftCorner,
      LootFrameInsetBottomRightCorner,
    }) do
        v:SetVertexColor(.3, .3, .3)
    end
    for i, v in pairs({
      LootFrameBg,
      LootFrameTitleBg,
      LootFrameInsetBg }) do
        v:SetVertexColor(.3, .3, .3)
    end
  end
end