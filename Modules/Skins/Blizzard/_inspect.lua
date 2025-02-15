local Module = SUI:NewModule("Skins.Inspect");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_InspectUI" then
                SUI:Skin(InspectFrame)
                SUI:Skin(InspectFrame.NineSlice)
                SUI:Skin(InspectFrameInset)
                SUI:Skin(InspectFrameInset.NineSlice)
                SUI:Skin(InspectPaperDollItemsFrame)
                SUI:Skin(InspectPaperDollItemsFrame.InspectTalents)
                SUI:Skin(InspectPVPFrame)
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
                }, false, true)

                -- Tabs
                SUI:Skin(InspectFrameTab1)
                SUI:Skin(InspectFrameTab2)
                SUI:Skin(InspectFrameTab3)

                -- Hide
                InspectMainHandSlotFrame:Hide()
                _G.select(InspectMainHandSlot:GetNumRegions(), InspectMainHandSlot:GetRegions()):Hide()
                _G.select(InspectSecondaryHandSlot:GetNumRegions(), InspectSecondaryHandSlot:GetRegions()):Hide()
            end

            if name == "Blizzard_Professions" then
                SUI:Skin(InspectRecipeFrame)
                SUI:Skin(InspectRecipeFrame.NineSlice)
            end
        end)
    end
end
