local Module = SUI:NewModule("Skins.SpellBook");

function Module:OnEnable()
    for i, v in pairs({ SpellBookFrame.NineSlice.TopEdge,
      SpellBookFrame.NineSlice.RightEdge,
      SpellBookFrame.NineSlice.LeftEdge,
      SpellBookFrame.NineSlice.TopEdge,
      SpellBookFrame.NineSlice.BottomEdge,
      SpellBookFrame.NineSlice.PortraitFrame,
      SpellBookFrame.NineSlice.TopRightCorner,
      SpellBookFrame.NineSlice.TopLeftCorner,
      SpellBookFrame.NineSlice.BottomLeftCorner,
      SpellBookFrame.NineSlice.BottomRightCorner,
      SpellBookFrameInset.NineSlice.BottomEdge, }) do
        v:SetVertexColor(unpack(SUI:Color(0.15)))
    end
    for i, v in pairs({
      SpellBookFrame.Bg,
      SpellBookFrame.TitleBg,
      SpellBookFrameInset.Bg }) do
        v:SetVertexColor(unpack(SUI:Color()))
    end
    SpellBookFrameInset:SetAlpha(0)
end