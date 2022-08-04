local Module = SUI:NewModule("Skins.Friendlist");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      FriendFrameTopBorder,
      FriendsFrameTopEdge,
      FriendsFrameTopEdge,
      FriendsFrameTopRightCorner,
      FriendsFrameRightEdge,
      FriendsFrameBottomRightCorner,
      FriendsFrameBottomEdge,
      FriendsFrameBottomLeftCorner,
      FriendsFrameLeftEdge,
      FriendsFrameTopLeftCorner,
      FriendsFrameBorderTopEdge,
      FriendsFrameBorderRightEdge,
      FriendsFrameBorderBottomEdge,
      FriendsFrameBorderLeftEdge,
      FriendsFrameBorderTopRightCorner,
      FriendsFrameBorderTopLeftCorner,
      FriendsFrameBorderBottomLeftCorner,
      FriendsFrameBorderBottomRightCorner, }) do
        v:SetVertexColor(unpack(SUI:Color(0.15)))
    end
    for i, v in pairs({
      FriendsFrameBg,
      FriendsFrameTitleBg,
      FriendsFrameInsetTopEdge,
      FriendsFrameInsetTopEdge,
      FriendsFrameInsetTopRightCorner,
      FriendsFrameInsetRightEdge,
      FriendsFrameInsetBottomRightCorner,
      FriendsFrameInsetBottomEdge,
      FriendsFrameInsetBottomLeftCorner,
      FriendsFrameInsetLeftEdge,
      FriendsFrameInsetTopLeftCorner }) do
        v:SetVertexColor(unpack(SUI:Color()))
    end
    for i, v in pairs({
      FriendsFrameFriendsScrollFrameTop,
      FriendsFrameFriendsScrollFrameMiddle,
      FriendsFrameFriendsScrollFrameBottom,
      FriendsFrameFriendsScrollFrameThumbTexture,
      FriendsFrameFriendsScrollFrameScrollUpButtonNormal,
      FriendsFrameFriendsScrollFrameScrollDownButtonNormal,
      FriendsFrameFriendsScrollFrameScrollUpButtonDisabled,
      FriendsFrameFriendsScrollFrameScrollDownButtonDisabled,
    }) do
      v:SetVertexColor(unpack(SUI:Color()))
    end
  end
end