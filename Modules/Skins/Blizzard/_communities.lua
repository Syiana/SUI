local Module = SUI:NewModule("Skins.Communities");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_Communities" then
        for i, v in pairs({
          communitiesFrameTopBorder,
          CommunitiesFrameTopEdge,
          CommunitiesFrameRightEdge,
          CommunitiesFrameBottomEdge,
          CommunitiesFrameLeftEdge,
          CommunitiesFrameTopRightCorner,
          CommunitiesFrameTopLeftCorner,
          CommunitiesFrameBottomLeftCorner,
          CommunitiesFrameBottomRightCorner,
          CommunitiesFrameGuildMemberDetailFrameBorderTopEdge,
          CommunitiesFrameGuildMemberDetailFrameBorderRightEdge,
          CommunitiesFrameGuildMemberDetailFrameBorderBottomEdge,
          CommunitiesFrameGuildMemberDetailFrameBorderLeftEdge,
          CommunitiesFrameGuildMemberDetailFrameBorderTopRightCorner,
          CommunitiesFrameGuildMemberDetailFrameBorderTopLeftCorner,
          CommunitiesFrameGuildMemberDetailFrameBorderBottomLeftCorner,
          CommunitiesFrameGuildMemberDetailFrameBorderBottomRightCorner, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
          CommunitiesFrameBg,
          CommunitiesFrameTitleBg,
          CommunitiesFrameInsetBg,
          CommunitiesFrameMemberListColumnDisplayBackground,

          }) do
            v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          CommunitiesFrameInsetTopEdge,
          CommunitiesFrameInsetRightEdge,
          CommunitiesFrameInsetBottomEdge,
          CommunitiesFrameInsetLeftEdge,
          CommunitiesFrameInsetTopRightCorner,
          CommunitiesFrameInsetTopLeftCorner,
          CommunitiesFrameInsetBottomLeftCorner,
          CommunitiesFrameInsetBottomRightCorner,
          CommunitiesFrameCommunitiesListInsetFrameTopEdge,
          CommunitiesFrameCommunitiesListInsetFrameRightEdge,
          CommunitiesFrameCommunitiesListInsetFrameBottomEdge,
          CommunitiesFrameCommunitiesListInsetFrameLeftEdge,
          CommunitiesFrameCommunitiesListInsetFrameTopRightCorner,
          CommunitiesFrameCommunitiesListInsetFrameTopLeftCorner,
          CommunitiesFrameCommunitiesListInsetFrameBottomLeftCorner,
          CommunitiesFrameCommunitiesListInsetFrameBottomRightCorner,
          CommunitiesFrameChatEditBoxLeft,
          CommunitiesFrameChatEditBoxMid,
          CommunitiesFrameChatEditBoxRight,
          CommunitiesFrameChatInsetFrameTopEdge,
          CommunitiesFrameChatInsetFrameRightEdge,
          CommunitiesFrameChatInsetFrameBottomEdge,
          CommunitiesFrameChatInsetFrameLeftEdge,
          CommunitiesFrameChatInsetFrameTopRightCorner,
          CommunitiesFrameChatInsetFrameTopLeftCorner,
          CommunitiesFrameChatInsetFrameBottomLeftCorner,
          CommunitiesFrameChatInsetFrameBottomRightCorner,
          CommunitiesFrameMemberListInsetFrameTopEdge,
          CommunitiesFrameMemberListInsetFrameRightEdge,
          CommunitiesFrameMemberListInsetFrameBottomEdge,
          CommunitiesFrameMemberListInsetFrameLeftEdge,
          CommunitiesFrameMemberListInsetFrameTopRightCorner,
          CommunitiesFrameMemberListInsetFrameTopLeftCorner,
          CommunitiesFrameMemberListInsetFrameBottomLeftCorner,
          CommunitiesFrameMemberListInsetFrameBottomRightCorner, }) do
            v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          CommunitiesFrameCommunitiesListTopFiligree,
          CommunitiesFrameCommunitiesListBottomFiligree,
          CommunitiesFrameCommunitiesListBg}) do
            v:SetVertexColor(.5, .5, .5)
        end
        for i, v in pairs({
          CommunitiesFrameMemberListListScrollFramescrollBarthumbTexture,
          CommunitiesFrameMemberListListScrollFramescrollBarScrollBarTop,
          CommunitiesFrameMemberListListScrollFramescrollBarScrollBarMiddle,
          CommunitiesFrameMemberListListScrollFramescrollBarScrollBarBottom,
          CommunitiesFrameMemberListListScrollFramescrollBarScrollUpButtonNormal,
          CommunitiesFrameMemberListListScrollFramescrollBarScrollDownButtonNormal,
          CommunitiesFrameMemberListListScrollFramescrollBarScrollUpButtonDisabled,
          CommunitiesFrameMemberListListScrollFramescrollBarScrollDownButtonDisabled,
          CommunitiesFrameCommunitiesListListScrollFrameThumbTexture,
          CommunitiesFrameCommunitiesListListScrollFrameTop,
          CommunitiesFrameCommunitiesListListScrollFrameMiddle,
          CommunitiesFrameCommunitiesListListScrollFrameBottom,
          CommunitiesFrameCommunitiesListListScrollFrameScrollUpButtonNormal,
          CommunitiesFrameCommunitiesListListScrollFrameScrollDownButtonNormal,
          CommunitiesFrameCommunitiesListListScrollFrameScrollUpButtonDisabled,
          CommunitiesFrameCommunitiesListListScrollFrameScrollDownButtonDisabled,
          CommunitiesFrameChatMessageFrameScrollBarthumbTexture,
          CommunitiesFrameChatMessageFrameScrollBarScrollBarTop,
          CommunitiesFrameChatMessageFrameScrollBarScrollBarMiddle,
          CommunitiesFrameChatMessageFrameScrollBarScrollBarBottom,
          CommunitiesFrameChatMessageFrameScrollBarScrollUpNormal,
          CommunitiesFrameChatMessageFrameScrollBarScrollDownNormal,
          CommunitiesFrameChatMessageFrameScrollBarScrollUpDisabled,
          CommunitiesFrameChatMessageFrameScrollBarScrollDownDisabled, }) do
          v:SetVertexColor(.4, .4, .4)
        end
      end
    end)
  end
end