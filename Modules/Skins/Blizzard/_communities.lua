local Module = SUI:NewModule("Skins.Communities");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_Communities" then
        for i, v in pairs({
          CommunitiesFrame.NineSlice.TopEdge,
          CommunitiesFrame.NineSlice.RightEdge,
          CommunitiesFrame.NineSlice.BottomEdge,
          CommunitiesFrame.NineSlice.LeftEdge,
          CommunitiesFrame.NineSlice.TopRightCorner,
          CommunitiesFrame.NineSlice.TopLeftCorner,
          CommunitiesFrame.NineSlice.BottomLeftCorner,
          CommunitiesFrame.NineSlice.BottomRightCorner,
          CommunitiesFrame.GuildMemberDetailFrame.Border.TopEdge,
          CommunitiesFrame.GuildMemberDetailFrame.Border.RightEdge,
          CommunitiesFrame.GuildMemberDetailFrame.Border.BottomEdge,
          CommunitiesFrame.GuildMemberDetailFrame.Border.LeftEdge,
          CommunitiesFrame.GuildMemberDetailFrame.Border.TopRightCorner,
          CommunitiesFrame.GuildMemberDetailFrame.Border.TopLeftCorner,
          CommunitiesFrame.GuildMemberDetailFrame.Border.BottomLeftCorner,
          CommunitiesFrame.GuildMemberDetailFrame.Border.BottomRightCorner, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
          CommunitiesFrame.Bg,
          CommunitiesFrame.TitleBg,
          CommunitiesFrameInset.Bg,
          CommunitiesFrame.MemberList.ColumnDisplay.Background,

          }) do
            v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          CommunitiesFrameInset.NineSlice.TopEdge,
          CommunitiesFrameInset.NineSlice.RightEdge,
          CommunitiesFrameInset.NineSlice.BottomEdge,
          CommunitiesFrameInset.NineSlice.LeftEdge,
          CommunitiesFrameInset.NineSlice.TopRightCorner,
          CommunitiesFrameInset.NineSlice.TopLeftCorner,
          CommunitiesFrameInset.NineSlice.BottomLeftCorner,
          CommunitiesFrameInset.NineSlice.BottomRightCorner,
          CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.TopEdge,
          CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.RightEdge,
          CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.BottomEdge,
          CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.LeftEdge,
          CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.TopRightCorner,
          CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.TopLeftCorner,
          CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.BottomLeftCorner,
          CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.BottomRightCorner,
          CommunitiesFrame.ChatEditBox.Left,
          CommunitiesFrame.ChatEditBox.Mid,
          CommunitiesFrame.ChatEditBox.Right,
          CommunitiesFrame.Chat.InsetFrame.NineSlice.TopEdge,
          CommunitiesFrame.Chat.InsetFrame.NineSlice.RightEdge,
          CommunitiesFrame.Chat.InsetFrame.NineSlice.BottomEdge,
          CommunitiesFrame.Chat.InsetFrame.NineSlice.LeftEdge,
          CommunitiesFrame.Chat.InsetFrame.NineSlice.TopRightCorner,
          CommunitiesFrame.Chat.InsetFrame.NineSlice.TopLeftCorner,
          CommunitiesFrame.Chat.InsetFrame.NineSlice.BottomLeftCorner,
          CommunitiesFrame.Chat.InsetFrame.NineSlice.BottomRightCorner,
          CommunitiesFrame.MemberList.InsetFrame.NineSlice.TopEdge,
          CommunitiesFrame.MemberList.InsetFrame.NineSlice.RightEdge,
          CommunitiesFrame.MemberList.InsetFrame.NineSlice.BottomEdge,
          CommunitiesFrame.MemberList.InsetFrame.NineSlice.LeftEdge,
          CommunitiesFrame.MemberList.InsetFrame.NineSlice.TopRightCorner,
          CommunitiesFrame.MemberList.InsetFrame.NineSlice.TopLeftCorner,
          CommunitiesFrame.MemberList.InsetFrame.NineSlice.BottomLeftCorner,
          CommunitiesFrame.MemberList.InsetFrame.NineSlice.BottomRightCorner, }) do
            v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          CommunitiesFrameCommunitiesList.TopFiligree,
          CommunitiesFrameCommunitiesList.BottomFiligree,
          CommunitiesFrameCommunitiesList.Bg}) do
            v:SetVertexColor(.5, .5, .5)
        end
        for i, v in pairs({
          CommunitiesFrameCommunitiesListListScrollFrameThumbTexture,
          CommunitiesFrameCommunitiesListListScrollFrameTop,
          CommunitiesFrameCommunitiesListListScrollFrameMiddle,
          CommunitiesFrameCommunitiesListListScrollFrameBottom,
          CommunitiesFrame.Chat.MessageFrame.ScrollBar.thumbTexture,
          CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollBarTop,
          CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollBarMiddle,
          CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollBarBottom,
          CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollUp.Normal,
          CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollDown.Normal,
          CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollUp.Disabled,
          CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollDown.Disabled, }) do
          v:SetVertexColor(.4, .4, .4)
        end
      end
    end)
  end
end