local Module = SUI:NewModule("Skins.SpellBook");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      SpellBookFrameTopEdge,
      SpellBookFrameRightEdge,
      SpellBookFrameLeftEdge,
      SpellBookFrameTopEdge,
      SpellBookFrameBottomEdge,
      SpellBookFramePortraitFrame,
      SpellBookFrameTopRightCorner,
      SpellBookFrameTopLeftCorner,
      SpellBookFrameBottomLeftCorner,
      SpellBookFrameBottomRightCorner,
      SpellBookFrameInsetBottomEdge,
    }) do
        v:SetVertexColor(unpack(SUI:Color(0.15)))
    end
    for i, v in pairs({
      SpellBookFrameBg,
      SpellBookFrameTitleBg,
      SpellBookFrameInsetBg }) do
        v:SetVertexColor(unpack(SUI:Color()))
    end
  end
end