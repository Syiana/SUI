local Module = SUI:NewModule("Skins.Guild");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      GuildRegistrarFrameTopEdge,
      GuildRegistrarFrameRightEdge,
      GuildRegistrarFrameBottomEdge,
      GuildRegistrarFrameLeftEdge,
      GuildRegistrarFrameTopRightCorner,
      GuildRegistrarFrameTopLeftCorner,
      GuildRegistrarFrameBottomLeftCorner,
      GuildRegistrarFrameBottomRightCorner,
      TabardFrameTopEdge,
      TabardFrameRightEdge,
      TabardFrameBottomEdge,
      TabardFrameLeftEdge,
      TabardFrameTopRightCorner,
      TabardFrameTopLeftCorner,
      TabardFrameBottomLeftCorner,
      TabardFrameBottomRightCorner,
    }) do
      v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      GuildRegistrarFrameBg,
      GuildRegistrarFrameTitleBg,
      GuildRegistrarFrameInsetBg,
      TabardFrameBg,
      TabardFrameTitleBg,
      TabardFrameInsetBg }) do
        v:SetVertexColor(.3, .3, .3)
    end
  end
end