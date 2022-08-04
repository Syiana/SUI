local Module = SUI:NewModule("Skins.Chat");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      ChatFrame1EditBoxLeft,
      ChatFrame1EditBoxRight,
      ChatFrame1EditBoxMid,
      ChatFrame2EditBoxLeft,
      ChatFrame2EditBoxRight,
      ChatFrame2EditBoxMid,
      ChatFrame3EditBoxLeft,
      ChatFrame3EditBoxRight,
      ChatFrame3EditBoxMid,
      ChatFrame4EditBoxLeft,
      ChatFrame4EditBoxRight,
      ChatFrame4EditBoxMid,
      ChatFrame5EditBoxLeft,
      ChatFrame5EditBoxRight,
      ChatFrame5EditBoxMid,
      ChatFrame6EditBoxLeft,
      ChatFrame6EditBoxRight,
      ChatFrame6EditBoxMid,
      ChatFrame7EditBoxLeft,
      ChatFrame7EditBoxRight,
      ChatFrame7EditBoxMid,
    }) do
      v:SetVertexColor(.15, .15, .15)
  end
  for i, v in pairs({
    ChannelFrameTopEdge,
    ChannelFrameTopEdge,
    ChannelFrameTopRightCorner,
    ChannelFrameRightEdge,
    ChannelFrameBottomRightCorner,
    ChannelFrameBottomEdge,
    ChannelFrameBottomLeftCorner,
    ChannelFrameLeftEdge,
    ChannelFrameTopLeftCorner,
    ChannelFrameLeftInsetBottomEdge,
    ChannelFrameLeftInsetBottomLeftCorner,
    ChannelFrameLeftInsetBottomRightCorner,
    ChannelFrameRightInsetBottomEdge,
    ChannelFrameRightInsetBottomLeftCorner,
    ChannelFrameRightInsetBottomRightCorner,
    ChannelFrameInsetBottomEdge,
  }) do
    v:SetVertexColor(.15, .15, .15)
  end
  for i, v in pairs({
  ChannelFrameBg,
  ChannelFrameTitleBg,
  ChannelFrameInsetBg }) do
    v:SetVertexColor(.3, .3, .3)
  end
  end
end