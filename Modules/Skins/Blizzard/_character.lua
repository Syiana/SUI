local Module = SUI:NewModule("Skins.Character");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      CharacterFrameRightEdge,
      CharacterFrameLeftEdge,
      CharacterFrameTopEdge,
      CharacterFrameBottomEdge,
      CharacterFramePortraitFrame,
      CharacterFrameTopRightCorner,
      CharacterFrameTopLeftCorner,
      CharacterFrameBottomLeftCorner,
      CharacterFrameBottomRightCorner,
      TokenFramePopupBorderTopEdge,
      TokenFramePopupBorderRightEdge,
      TokenFramePopupBorderBottomEdge,
      TokenFramePopupBorderLeftEdge,
      TokenFramePopupBorderTopRightCorner,
      TokenFramePopupBorderTopLeftCorner,
      TokenFramePopupBorderBottomLeftCorner,
      TokenFramePopupBorderBottomRightCorner,
      ReputationDetailFrameBorderTopEdge,
      ReputationDetailFrameBorderRightEdge,
      ReputationDetailFrameBorderBottomEdge,
      ReputationDetailFrameBorderLeftEdge,
      ReputationDetailFrameBorderTopRightCorner,
      ReputationDetailFrameBorderTopLeftCorner,
      ReputationDetailFrameBorderBottomLeftCorner,
      ReputationDetailFrameBorderBottomRightCorner
    }) do
        v:SetVertexColor(unpack(SUI:Color(0.15)))
    end

    for i, v in pairs({
      CharacterFrameBg,
      CharacterFrameTitleBg,
      CharacterFrameInsetRightEdge,
      CharacterFrameInsetLeftEdge,
      CharacterFrameInsetTopEdge,
      CharacterFrameInsetBottomEdge,
      CharacterFrameInsetPortraitFrame,
      CharacterFrameInsetTopRightCorner,
      CharacterFrameInsetTopLeftCorner,
      CharacterFrameInsetBottomLeftCorner,
      CharacterFrameInsetBottomRightCorner,
      CharacterFrameInsetRightRightEdge,
      CharacterFrameInsetRightLeftEdge,
      CharacterFrameInsetRightTopEdge,
      CharacterFrameInsetRightBottomEdge,
      CharacterFrameInsetRightPortraitFrame,
      CharacterFrameInsetRightTopRightCorner,
      CharacterFrameInsetRightTopLeftCorner,
      CharacterFrameInsetRightBottomLeftCorner,
      CharacterFrameInsetRightBottomRightCorner,
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

    for i, v in pairs({
      ReputationListScrollFrameScrollBarThumbTexture,
      ReputationListScrollFrameScrollBarScrollUpButtonNormal,
      ReputationListScrollFrameScrollBarScrollDownButtonNormal,
      ReputationListScrollFrameScrollBarScrollUpButtonDisabled,
      ReputationListScrollFrameScrollBarScrollDownButtonDisabled,

    }) do
      v:SetVertexColor(.4, .4, .4)
    end
    _G.select(1, ReputationListScrollFrame:GetRegions()):SetVertexColor(.4, .4, .4)
    _G.select(2, ReputationListScrollFrame:GetRegions()):SetVertexColor(.4, .4, .4)

    for i, v in pairs({
      TokenFrameContainerScrollBarTop,
      TokenFrameContainerScrollBarMiddle,
      TokenFrameContainerScrollBarBottom,
      TokenFrameContainerScrollBarThumbTexture,
      TokenFrameContainerScrollBarScrollUpButtonNormal,
      TokenFrameContainerScrollBarScrollDownButtonNormal,
      TokenFrameContainerScrollBarScrollUpButtonDisabled,
      TokenFrameContainerScrollBarScrollDownButtonDisabled,

    }) do
      v:SetVertexColor(.4, .4, .4)
    end
  end
end