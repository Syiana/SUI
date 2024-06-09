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
            CharacterStatsPane.ClassBackground,
            CharacterFrameInsetRight.Bg,
            CharacterFrameTab1.Left,
            CharacterFrameTab1.Middle,
            CharacterFrameTab1.Right,
            CharacterFrameTab1.LeftActive,
            CharacterFrameTab1.MiddleActive,
            CharacterFrameTab1.RightActive,
            CharacterFrameTab1.LeftHighlight,
            CharacterFrameTab1.MiddleHighlight,
            CharacterFrameTab1.RightHighlight,
            CharacterFrameTab2.Left,
            CharacterFrameTab2.Middle,
            CharacterFrameTab2.Right,
            CharacterFrameTab2.LeftActive,
            CharacterFrameTab2.MiddleActive,
            CharacterFrameTab2.RightActive,
            CharacterFrameTab2.LeftHighlight,
            CharacterFrameTab2.MiddleHighlight,
            CharacterFrameTab2.RightHighlight,
            CharacterFrame.Background
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
    end
end
