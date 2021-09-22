local Module = SUI:NewModule("Skins.Gossip");

function Module:OnEnable()
  for i, v in pairs({
    GossipFrame.NineSlice.TopEdge,
    GossipFrame.NineSlice.RightEdge,
    GossipFrame.NineSlice.BottomEdge,
    GossipFrame.NineSlice.LeftEdge,
    GossipFrame.NineSlice.TopRightCorner,
    GossipFrame.NineSlice.TopLeftCorner,
    GossipFrame.NineSlice.BottomLeftCorner,
    GossipFrame.NineSlice.BottomRightCorner,
  }) do
    v:SetVertexColor(.15, .15, .15)
  end
  for i, v in pairs({
    GossipFrameInset.NineSlice.TopEdge,
    GossipFrameInset.NineSlice.RightEdge,
    GossipFrameInset.NineSlice.BottomEdge,
    GossipFrameInset.NineSlice.LeftEdge,
    GossipFrameInset.NineSlice.TopRightCorner,
    GossipFrameInset.NineSlice.TopLeftCorner,
    GossipFrameInset.NineSlice.BottomLeftCorner,
    GossipFrameInset.NineSlice.BottomRightCorner
  }) do
    v:SetVertexColor(.3, .3, .3)
  end
  for i, v in pairs({
    GossipFrame.Bg,
    GossipFrame.TitleBg,
    GossipFrameInset.Bg }) do
      v:SetVertexColor(.3, .3, .3)
  end
  for i, v in pairs({
    GossipGreetingScrollFrameTop,
    GossipGreetingScrollFrameMiddle,
    GossipGreetingScrollFrameBottom,
    GossipGreetingScrollFrameScrollBarThumbTexture,
    GossipGreetingScrollFrameScrollBarScrollUpButton.Normal,
    GossipGreetingScrollFrameScrollBarScrollDownButton.Normal,
    GossipGreetingScrollFrameScrollBarScrollUpButton.Disabled,
    GossipGreetingScrollFrameScrollBarScrollDownButton.Disabled,

  }) do
    v:SetVertexColor(.4, .4, .4)
  end

end