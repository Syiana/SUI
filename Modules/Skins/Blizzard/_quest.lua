local Module = SUI:NewModule("Skins.Quest");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      QuestFrameTopEdge,
      QuestFrameRightEdge,
      QuestFrameBottomEdge,
      QuestFrameLeftEdge,
      QuestFrameTopRightCorner,
      QuestFrameTopLeftCorner,
      QuestFrameBottomLeftCorner,
      QuestFrameBottomRightCorner,
      QuestFrameInsetBottomEdge,
      QuestLogPopupDetailFrameTopEdge,
      QuestLogPopupDetailFrameRightEdge,
      QuestLogPopupDetailFrameBottomEdge,
      QuestLogPopupDetailFrameLeftEdge,
      QuestLogPopupDetailFrameTopRightCorner,
      QuestLogPopupDetailFrameTopLeftCorner,
      QuestLogPopupDetailFrameBottomLeftCorner,
      QuestLogPopupDetailFrameBottomRightCorner,
      QuestLogPopupDetailFrameBottomEdge,
      QuestNPCModelTopBorder,
      QuestNPCModelRightBorder,
      QuestNPCModelTopRightCorner,
      QuestNPCModelBottomRightCorner,
      QuestNPCModelBottomBorder,
      QuestNPCModelBottomLeftCorner,
      QuestNPCModelLeftBorder,
      QuestNPCModelTopLeftCorner,
      QuestNPCModelTextTopBorder,
      QuestNPCModelTextRightBorder,
      QuestNPCModelTextTopRightCorner,
      QuestNPCModelTextBottomRightCorner,
      QuestNPCModelTextBottomBorder,
      QuestNPCModelTextBottomLeftCorner,
      QuestNPCModelTextLeftBorder,
      QuestNPCModelTextTopLeftCorner, 
    }) do
      v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      QuestFrameBg,
      QuestFrameTitleBg,
      QuestFrameInsetBg }) do
        v:SetVertexColor(.3, .3, .3)
    end
  end
end