local Module = SUI:NewModule("Skins.Inspect");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_InspectUI" then
                SUI:Skin(InspectFrame, true)
                SUI:Skin(InspectFrame.NineSlice, true)
                SUI:Skin(InspectFrameInset, true)
                SUI:Skin(InspectFrameInset.NineSlice, true)
                SUI:Skin(InspectPaperDollItemsFrame, true)
                SUI:Skin(InspectPaperDollItemsFrame.InspectTalents, true)
                SUI:Skin(InspectPVPFrame, true)
                SUI:Skin({
                    InspectModelFrameBorderLeft,
                    InspectModelFrameBorderRight,
                    InspectModelFrameBorderTop,
                    InspectModelFrameBorderTopLeft,
                    InspectModelFrameBorderTopRight,
                    InspectModelFrameBorderBottom,
                    InspectModelFrameBorderBottomLeft,
                    InspectModelFrameBorderBottomRight,
                    InspectModelFrameBorderBottom2,
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
                    InspectSecondaryHandSlotFrame,
                }, true, true)

                -- Tabs
                SUI:Skin(InspectFrameTab1, true)
                SUI:Skin(InspectFrameTab2, true)
                SUI:Skin(InspectFrameTab3, true)

                -- Hide
                InspectMainHandSlotFrame:Hide()
                _G.select(InspectMainHandSlot:GetNumRegions(), InspectMainHandSlot:GetRegions()):Hide()
                _G.select(InspectSecondaryHandSlot:GetNumRegions(), InspectSecondaryHandSlot:GetRegions()):Hide()
            end

            if name == "Blizzard_Professions" then
                SUI:Skin(InspectRecipeFrame, true)
                SUI:Skin(InspectRecipeFrame.NineSlice, true)
            end
        end)
    end
end
