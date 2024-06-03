local Module = SUI:NewModule("Skins.Dressup");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({ 
      DressUpFrameTopEdge,
      DressUpFrameRightEdge,
      DressUpFrameBottomEdge,
      DressUpFrameLeftEdge,
      DressUpFrameTopRightCorner,
      DressUpFrameTopLeftCorner,
      DressUpFrameBottomLeftCorner,
      DressUpFrameBottomRightCorner,
      DressUpFrameInsetBottomEdge,
    }) do
      v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      DressUpFrameBg,
      DressUpFrameTitleBg,
      DressUpFrameInsetBg }) do
        v:SetVertexColor(.3, .3, .3)
    end
    for i, v in pairs({
      DressUpFrameInsetTopEdge,
      DressUpFrameInsetTopRightCorner,
      DressUpFrameInsetRightEdge,
      DressUpFrameInsetBottomRightCorner,
      DressUpFrameInsetBottomEdge,
      DressUpFrameInsetBottomLeftCorner,
      DressUpFrameInsetLeftEdge,
      DressUpFrameInsetTopLeftCorner }) do
        v:SetVertexColor(.3, .3, .3)
    end
  end
end