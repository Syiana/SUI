local Module = SUI:NewModule("Skins.Gossip");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      GossipFrameTopEdge,
      GossipFrameRightEdge,
      GossipFrameBottomEdge,
      GossipFrameLeftEdge,
      GossipFrameTopRightCorner,
      GossipFrameTopLeftCorner,
      GossipFrameBottomLeftCorner,
      GossipFrameBottomRightCorner,
    }) do
      v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      GossipFrameInsetTopEdge,
      GossipFrameInsetRightEdge,
      GossipFrameInsetBottomEdge,
      GossipFrameInsetLeftEdge,
      GossipFrameInsetTopRightCorner,
      GossipFrameInsetTopLeftCorner,
      GossipFrameInsetBottomLeftCorner,
      GossipFrameInsetBottomRightCorner
    }) do
      v:SetVertexColor(.3, .3, .3)
    end
    for i, v in pairs({
      GossipFrameBg,
      GossipFrameTitleBg,
      GossipFrameInsetBg }) do
        v:SetVertexColor(.3, .3, .3)
    end
    for i, v in pairs({
      GossipGreetingScrollFrameTop,
      GossipGreetingScrollFrameMiddle,
      GossipGreetingScrollFrameBottom,
      GossipGreetingScrollFrameScrollBarThumbTexture,
      GossipGreetingScrollFrameScrollBarScrollUpButtonNormal,
      GossipGreetingScrollFrameScrollBarScrollDownButtonNormal,
      GossipGreetingScrollFrameScrollBarScrollUpButtonDisabled,
      GossipGreetingScrollFrameScrollBarScrollDownButtonDisabled,

    }) do
      v:SetVertexColor(.4, .4, .4)
    end
  end
end