local Module = SUI:NewModule("Skins.Map");

function Module:OnEnable()
  if (SUI:Color()) then
      for i, v in pairs({
        WorldMapFrameBorderFrameTopEdge,
        WorldMapFrameBorderFrameTopEdge,
        WorldMapFrameBorderFrameTopEdge,
        WorldMapFrameBorderFrameTopRightCorner,
        WorldMapFrameBorderFrameRightEdge,
        WorldMapFrameBorderFrameBottomRightCorner,
        WorldMapFrameBorderFrameBottomEdge,
        WorldMapFrameBorderFrameBottomLeftCorner,
        WorldMapFrameBorderFrameLeftEdge,
        WorldMapFrameBorderFrameTopLeftCorner,
      }) do
        v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      WorldMapFrameInsetBorderBottom,
      WorldMapFrameInsetBorderBottomLeft,
      WorldMapFrameInsetBorderBottomRight,
      WorldMapFrameInsetBorderLeft,
      WorldMapFrameInsetBorderRight, }) do
        v:SetVertexColor(.3, .3, .3)
    end
    for i, v in pairs({
      WorldMapFrameBg,
      WorldMapFrameTitleBg, }) do
        v:SetVertexColor(.3, .3, .3)
    end
  end
end