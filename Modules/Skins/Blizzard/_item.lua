local Module = SUI:NewModule("Skins.Item");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      ItemTextFrameTopEdge,
      ItemTextFraightEdge,
      ItemTextFrameBottomEdge,
      ItemTextFrameLeftEdge,
      ItemTextFrameTopRightCorner,
      ItemTextFrameTopLeftCorner,
      ItemTextFrameBottomLeftCorner,
      ItemTextFrameBottomRightCorner,
    }) do
      v:SetVertexColor(.15, .15, .15)
    end

    -- PetitionFrame
    for i, v in pairs({
      PetitionFrameTopEdge,
      PetitionFrameRightEdge,
      PetitionFrameBottomEdge,
      PetitionFrameLeftEdge,
      PetitionFrameTopRightCorner,
      PetitionFrameTopLeftCorner,
      PetitionFrameBottomLeftCorner,
      PetitionFrameBottomRightCorner,
    }) do
        v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      PetitionFrameBg,
      PetitionFrameTitleBg,
      PetitionFrameInsetBg }) do
        v:SetVertexColor(.3, .3, .3)
    end
  end
end