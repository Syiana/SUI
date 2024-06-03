local Module = SUI:NewModule("Skins.Mail");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      MailFrameTopEdge,
      MailFrameTopRightCorner,
      MailFrameRightEdge,
      MailFrameBottomRightCorner,
      MailFrameBottomEdge,
      MailFrameBottomLeftCorner,
      MailFrameLeftEdge,
      MailFrameTopLeftCorner,
      OpenMailFrameTopEdge,
      OpenMailFrameTopRightCorner,
      OpenMailFrameRightEdge,
      OpenMailFrameBottomRightCorner,
      OpenMailFrameBottomEdge,
      OpenMailFrameBottomLeftCorner,
      OpenMailFrameLeftEdge,
      OpenMailFrameTopLeftCorner, }) do
        v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      MailFrameInsetTopEdge,
      MailFrameInsetTopRightCorner,
      MailFrameInsetRightEdge,
      MailFrameInsetBottomRightCorner,
      MailFrameInsetBottomEdge,
      MailFrameInsetBottomLeftCorner,
      MailFrameInsetLeftEdge,
      MailFrameInsetTopLeftCorner,
      OpenMailFrameInsetTopEdge,
      OpenMailFrameInsetTopRightCorner,
      OpenMailFrameInsetRightEdge,
      OpenMailFrameInsetBottomRightCorner,
      OpenMailFrameInsetBottomEdge,
      OpenMailFrameInsetBottomLeftCorner,
      OpenMailFrameInsetLeftEdge,
      OpenMailFrameInsetTopLeftCorner,  }) do
        v:SetVertexColor(.3, .3, .3)
    end
    for i, v in pairs({
      MailFrameBg,
      MailFrameTitleBg,
      OpenMailFrameBg,
      OpenMailFrameTitleBg }) do
        v:SetVertexColor(.3, .3, .3)
    end
  end
end