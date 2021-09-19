local Module = SUI:NewModule("Skins.Bags");

function Module:OnEnable()
    -- Character
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
      ReputationDetailFrame.Border.BottomRightCorner }) do
        v:SetVertexColor(unpack(color.secondary))
    end
    for i, v in pairs({
      CharacterFrame.Bg,
      CharacterFrame.TitleBg, }) do
        v:SetVertexColor(unpack(color.primary))
    end
    for i, v in pairs({
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
      PaperDollInnerBorderBottom2 }) do
        v:SetVertexColor(unpack(color.primary))
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
      CharacterSecondaryHandSlotFrame }) do
        v:SetAlpha(0)
    end
    _G.select(CharacterMainHandSlot:GetNumRegions(), CharacterMainHandSlot:GetRegions()):SetAlpha(0)
    _G.select(CharacterSecondaryHandSlot:GetNumRegions(), CharacterSecondaryHandSlot:GetRegions()):SetAlpha(0)

    for i, v in pairs({
      ReputationListScrollFrameScrollBarThumbTexture,
      ReputationListScrollFrameScrollBarScrollUpButton.Normal,
      ReputationListScrollFrameScrollBarScrollDownButton.Normal,
      ReputationListScrollFrameScrollBarScrollUpButton.Disabled,
      ReputationListScrollFrameScrollBarScrollDownButton.Disabled,

    }) do
      v:SetVertexColor(unpack(color.primary))
    end
    _G.select(1, ReputationListScrollFrame:GetRegions()):SetVertexColor(unpack(color.primary))
    _G.select(2, ReputationListScrollFrame:GetRegions()):SetVertexColor(unpack(color.primary))

    for i, v in pairs({
      TokenFrameContainerScrollBarTop,
      TokenFrameContainerScrollBarMiddle,
      TokenFrameContainerScrollBarBottom,
      TokenFrameContainerScrollBarThumbTexture,
      TokenFrameContainerScrollBarScrollUpButton.Normal,
      TokenFrameContainerScrollBarScrollDownButton.Normal,
      TokenFrameContainerScrollBarScrollUpButton.Disabled,
      TokenFrameContainerScrollBarScrollDownButton.Disabled,

    }) do
      v:SetVertexColor(unpack(color.primary))
    end
end