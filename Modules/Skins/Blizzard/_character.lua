local Module = SUI:NewModule("Skins.Character");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      CharacterFrame.NineSlice.RightEdge,
      CharacterFrame.NineSlice.LeftEdge,
      CharacterFrame.NineSlice.TopEdge,
      CharacterFrame.NineSlice.BottomEdge,
      CharacterFrame.NineSlice.PortraitFrame,
      CharacterFrame.NineSlice.TopRightCorner,
      CharacterFrame.NineSlice.TopLeftCorner,
      CharacterFrame.NineSlice.BottomLeftCorner,
      CharacterFrame.NineSlice.BottomRightCorner,
      TokenFramePopup.Border.TopEdge,
      TokenFramePopup.Border.RightEdge,
      TokenFramePopup.Border.BottomEdge,
      TokenFramePopup.Border.LeftEdge,
      TokenFramePopup.Border.TopRightCorner,
      TokenFramePopup.Border.TopLeftCorner,
      TokenFramePopup.Border.BottomLeftCorner,
      TokenFramePopup.Border.BottomRightCorner,
      ReputationDetailFrame.Border.TopEdge,
      ReputationDetailFrame.Border.RightEdge,
      ReputationDetailFrame.Border.BottomEdge,
      ReputationDetailFrame.Border.LeftEdge,
      ReputationDetailFrame.Border.TopRightCorner,
      ReputationDetailFrame.Border.TopLeftCorner,
      ReputationDetailFrame.Border.BottomLeftCorner,
      ReputationDetailFrame.Border.BottomRightCorner
    }) do
        v:SetVertexColor(unpack(SUI:Color(0.15)))
    end

    for i, v in pairs({
      CharacterFrame.Bg,
      CharacterFrame.TitleBg,
      CharacterFrameInset.NineSlice.RightEdge,
      CharacterFrameInset.NineSlice.LeftEdge,
      CharacterFrameInset.NineSlice.TopEdge,
      CharacterFrameInset.NineSlice.BottomEdge,
      CharacterFrameInset.NineSlice.PortraitFrame,
      CharacterFrameInset.NineSlice.TopRightCorner,
      CharacterFrameInset.NineSlice.TopLeftCorner,
      CharacterFrameInset.NineSlice.BottomLeftCorner,
      CharacterFrameInset.NineSlice.BottomRightCorner,
      CharacterFrameInsetRight.NineSlice.RightEdge,
      CharacterFrameInsetRight.NineSlice.LeftEdge,
      CharacterFrameInsetRight.NineSlice.TopEdge,
      CharacterFrameInsetRight.NineSlice.BottomEdge,
      CharacterFrameInsetRight.NineSlice.PortraitFrame,
      CharacterFrameInsetRight.NineSlice.TopRightCorner,
      CharacterFrameInsetRight.NineSlice.TopLeftCorner,
      CharacterFrameInsetRight.NineSlice.BottomLeftCorner,
      CharacterFrameInsetRight.NineSlice.BottomRightCorner,
      PaperDollInnerBorderLeft,
      PaperDollInnerBorderRight,
      PaperDollInnerBorderTop,
      PaperDollInnerBorderTopLeft,
      PaperDollInnerBorderTopRight,
      PaperDollInnerBorderBottom,
      PaperDollInnerBorderBottomLeft,
      PaperDollInnerBorderBottomRight,
      PaperDollInnerBorderBottom2
    }) do
      v:SetVertexColor(unpack(SUI:Color()))
    end

    for i, v in pairs({
      CharacterFeetSlotFrame,
      CharacterHandsSlotFrame,
      CharacterWaistSlotFrame,
      CharacterLegsSlotFrame,
      CharacterFinger0SlotFrame,
      CharacterFinger1SlotFrame,
      CharacterTrinket0SlotFrame,
      CharacterTrinket1SlotFrame,
      CharacterWristSlotFrame,
      CharacterTabardSlotFrame,
      CharacterShirtSlotFrame,
      CharacterChestSlotFrame,
      CharacterBackSlotFrame,
      CharacterShoulderSlotFrame,
      CharacterNeckSlotFrame,
      CharacterHeadSlotFrame,
      CharacterMainHandSlotFrame,
      CharacterSecondaryHandSlotFrame,
      _G.select(CharacterMainHandSlot:GetNumRegions(), CharacterMainHandSlot:GetRegions()),
      _G.select(CharacterSecondaryHandSlot:GetNumRegions(), CharacterSecondaryHandSlot:GetRegions())
    }) do
      v:SetAlpha(0)
    end

    -- for i, v in pairs({
    --   ReputationListScrollFrameScrollBarThumbTexture,
    --   ReputationListScrollFrameScrollBarScrollUpButton.Normal,
    --   ReputationListScrollFrameScrollBarScrollDownButton.Normal,
    --   ReputationListScrollFrameScrollBarScrollUpButton.Disabled,
    --   ReputationListScrollFrameScrollBarScrollDownButton.Disabled,

    -- }) do
    --   v:SetVertexColor(.4, .4, .4)
    -- end
    -- _G.select(1, ReputationListScrollFrame:GetRegions()):SetVertexColor(.4, .4, .4)
    -- _G.select(2, ReputationListScrollFrame:GetRegions()):SetVertexColor(.4, .4, .4)

    -- for i, v in pairs({
    --   TokenFrameContainerScrollBarTop,
    --   TokenFrameContainerScrollBarMiddle,
    --   TokenFrameContainerScrollBarBottom,
    --   TokenFrameContainerScrollBarThumbTexture,
    --   TokenFrameContainerScrollBarScrollUpButton.Normal,
    --   TokenFrameContainerScrollBarScrollDownButton.Normal,
    --   TokenFrameContainerScrollBarScrollUpButton.Disabled,
    --   TokenFrameContainerScrollBarScrollDownButton.Disabled,

    -- }) do
    --   v:SetVertexColor(.4, .4, .4)
    -- end
  end
end