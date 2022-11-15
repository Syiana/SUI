local Module = SUI:NewModule("Skins.Mail");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      MailFrame.NineSlice.TopEdge,
      MailFrame.NineSlice.TopRightCorner,
      MailFrame.NineSlice.RightEdge,
      MailFrame.NineSlice.BottomRightCorner,
      MailFrame.NineSlice.BottomEdge,
      MailFrame.NineSlice.BottomLeftCorner,
      MailFrame.NineSlice.LeftEdge,
      MailFrame.NineSlice.TopLeftCorner,
      OpenMailFrame.NineSlice.TopEdge,
      OpenMailFrame.NineSlice.TopRightCorner,
      OpenMailFrame.NineSlice.RightEdge,
      OpenMailFrame.NineSlice.BottomRightCorner,
      OpenMailFrame.NineSlice.BottomEdge,
      OpenMailFrame.NineSlice.BottomLeftCorner,
      OpenMailFrame.NineSlice.LeftEdge,
      OpenMailFrame.NineSlice.TopLeftCorner, }) do
        v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      MailFrameInset.NineSlice.TopEdge,
      MailFrameInset.NineSlice.TopRightCorner,
      MailFrameInset.NineSlice.RightEdge,
      MailFrameInset.NineSlice.BottomRightCorner,
      MailFrameInset.NineSlice.BottomEdge,
      MailFrameInset.NineSlice.BottomLeftCorner,
      MailFrameInset.NineSlice.LeftEdge,
      MailFrameInset.NineSlice.TopLeftCorner,
      OpenMailFrameInset.NineSlice.TopEdge,
      OpenMailFrameInset.NineSlice.TopRightCorner,
      OpenMailFrameInset.NineSlice.RightEdge,
      OpenMailFrameInset.NineSlice.BottomRightCorner,
      OpenMailFrameInset.NineSlice.BottomEdge,
      OpenMailFrameInset.NineSlice.BottomLeftCorner,
      OpenMailFrameInset.NineSlice.LeftEdge,
      OpenMailFrameInset.NineSlice.TopLeftCorner,  }) do
        v:SetVertexColor(.3, .3, .3)
    end
    for i, v in pairs({
      MailFrame.Bg,
      MailFrame.TitleBg,
      OpenMailFrame.Bg,
      OpenMailFrame.TitleBg }) do
        v:SetVertexColor(.3, .3, .3)
    end
  end
end