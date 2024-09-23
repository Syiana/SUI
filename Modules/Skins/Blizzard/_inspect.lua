local Module = SUI:NewModule("Skins.Inspect");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_InspectUI" then
                for i, v in pairs({
                    InspectFrame.NineSlice.TopEdge,
                    InspectFrame.NineSlice.RightEdge,
                    InspectFrame.NineSlice.BottomEdge,
                    InspectFrame.NineSlice.LeftEdge,
                    InspectFrame.NineSlice.TopRightCorner,
                    InspectFrame.NineSlice.TopLeftCorner,
                    InspectFrame.NineSlice.BottomLeftCorner,
                    InspectFrame.NineSlice.BottomRightCorner,
                    InspectFrameInset.NineSlice.BottomEdge,
                    InspectFrameTab1.Left,
                    InspectFrameTab1.Middle,
                    InspectFrameTab1.Right,
                    InspectFrameTab1.LeftActive,
                    InspectFrameTab1.MiddleActive,
                    InspectFrameTab1.RightActive,
                    InspectFrameTab1.LeftHighlight,
                    InspectFrameTab1.MiddleHighlight,
                    InspectFrameTab1.RightHighlight,
                    InspectFrameTab2.Left,
                    InspectFrameTab2.Middle,
                    InspectFrameTab2.Right,
                    InspectFrameTab2.LeftActive,
                    InspectFrameTab2.MiddleActive,
                    InspectFrameTab2.RightActive,
                    InspectFrameTab2.LeftHighlight,
                    InspectFrameTab2.MiddleHighlight,
                    InspectFrameTab2.RightHighlight,
                    InspectFrameTab3.Left,
                    InspectFrameTab3.Middle,
                    InspectFrameTab3.Right,
                    InspectFrameTab3.LeftActive,
                    InspectFrameTab3.MiddleActive,
                    InspectFrameTab3.RightActive,
                    InspectFrameTab3.LeftHighlight,
                    InspectFrameTab3.MiddleHighlight,
                    InspectFrameTab3.RightHighlight,
                    InspectPaperDollItemsFrame.InspectTalents.Left,
                    InspectPaperDollItemsFrame.InspectTalents.Middle,
                    InspectPaperDollItemsFrame.InspectTalents.Right,
                    InspectPaperDollItemsFrame.InspectTalents.LeftActive,
                    InspectPaperDollItemsFrame.InspectTalents.MiddleActive,
                    InspectPaperDollItemsFrame.InspectTalents.RightActive,
                    InspectPaperDollItemsFrame.InspectTalents.LeftHighlight,
                    InspectPaperDollItemsFrame.InspectTalents.MiddleHighlight,
                    InspectPaperDollItemsFrame.InspectTalents.RightHighlight,
                    InspectPVPFrame.BG,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
                for i, v in pairs({
                    InspectFrame.Bg,
                    InspectFrame.TitleBg,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
                for i, v in pairs({
                    InspectFrameInset.NineSlice.RightEdge,
                    InspectFrameInset.NineSlice.LeftEdge,
                    InspectFrameInset.NineSlice.TopEdge,
                    InspectFrameInset.NineSlice.BottomEdge,
                    InspectFrameInset.NineSlice.PortraitFrame,
                    InspectFrameInset.NineSlice.TopRightCorner,
                    InspectFrameInset.NineSlice.TopLeftCorner,
                    InspectFrameInset.NineSlice.BottomLeftCorner,
                    InspectFrameInset.NineSlice.BottomRightCorner,
                    InspectModelFrameBorderLeft,
                    InspectModelFrameBorderRight,
                    InspectModelFrameBorderTop,
                    InspectModelFrameBorderTopLeft,
                    InspectModelFrameBorderTopRight,
                    InspectModelFrameBorderBottom,
                    InspectModelFrameBorderBottomLeft,
                    InspectModelFrameBorderBottomRight,
                    InspectModelFrameBorderBottom2,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
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
                    InspectSecondaryHandSlotFrame,
                }) do
                    v:SetAlpha(0)
                end
                _G.select(InspectMainHandSlot:GetNumRegions(), InspectMainHandSlot:GetRegions()):Hide()
                _G.select(InspectSecondaryHandSlot:GetNumRegions(), InspectSecondaryHandSlot:GetRegions()):Hide()
            end

            if name == "Blizzard_Professions" then
                for i, v in pairs ({
                    InspectRecipeFrame.NineSlice:GetRegions()
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
        end)
    end
end
