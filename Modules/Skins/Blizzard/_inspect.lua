local Module = SUI:NewModule("Skins.Inspect");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_InspectUI" then
        for i, v in pairs({ 
          InspectFrameTopEdge,
          InspectFrameRightEdge,
          InspectFrameBottomEdge,
          InspectFrameLeftEdge,
          InspectFrameTopRightCorner,
          InspectFrameTopLeftCorner,
          InspectFrameBottomLeftCorner,
          InspectFrameBottomRightCorner,
          InspectFrameInsetBottomEdge, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
          InspectFrame.Bg,
          InspectFrame.TitleBg }) do
            v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          InspectFrameInsetRightEdge,
          InspectFrameInsetLeftEdge,
          InspectFrameInsetTopEdge,
          InspectFrameInsetBottomEdge,
          InspectFrameInsetPortraitFrame,
          InspectFrameInsetTopRightCorner,
          InspectFrameInsetTopLeftCorner,
          InspectFrameInsetBottomLeftCorner,
          InspectFrameInsetBottomRightCorner,
          InspectModelFrameBorderLeft,
          InspectModelFrameBorderRight,
          InspectModelFrameBorderTop,
          InspectModelFrameBorderTopLeft,
          InspectModelFrameBorderTopRight,
          InspectModelFrameBorderBottom,
          InspectModelFrameBorderBottomLeft,
          InspectModelFrameBorderBottomRight,
          InspectModelFrameBorderBottom2 }) do
            v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          InspectFeetSlotFrame,
          InspectHandsSlotFrame,
          InspectWaistSlotFrame,
          InspectLegsSlotFrame,
          InspectFinger0SlotFrame,
          InspectFinger1SlotFrame,
          InspectTrinket0SlotFrame,
          InspectTrinket1SlotFrame,
          InspectWristSlotFrame,
          InspectTabardSlotFrame,
          InspectShirtSlotFrame,
          InspectChestSlotFrame,
          InspectBackSlotFrame,
          InspectShoulderSlotFrame,
          InspectNeckSlotFrame,
          InspectHeadSlotFrame,
          InspectMainHandSlotFrame,
          InspectSecondaryHandSlotFrame }) do
            v:SetAlpha(0)
        end
        _G.select(InspectMainHandSlot:GetNumRegions(), InspectMainHandSlot:GetRegions()):Hide()
        _G.select(InspectSecondaryHandSlot:GetNumRegions(), InspectSecondaryHandSlot:GetRegions()):Hide()
      end
    end)
  end
end