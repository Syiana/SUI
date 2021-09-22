local Module = SUI:NewModule("Skins.Petition");

function Module:OnEnable()
  for i, v in pairs({	PetitionFrame.NineSlice.TopEdge,
  PetitionFrame.NineSlice.RightEdge,
  PetitionFrame.NineSlice.BottomEdge,
  PetitionFrame.NineSlice.LeftEdge,
  PetitionFrame.NineSlice.TopRightCorner,
  PetitionFrame.NineSlice.TopLeftCorner,
  PetitionFrame.NineSlice.BottomLeftCorner,
  PetitionFrame.NineSlice.BottomRightCorner, }) do
    v:SetVertexColor(.15, .15, .15)
  end
  for i, v in pairs({
    PetitionFrame.Bg,
    PetitionFrame.TitleBg,
    PetitionFrameInset.Bg }) do
      v:SetVertexColor(.3, .3, .3)
  end
end