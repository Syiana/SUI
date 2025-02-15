local Module = SUI:NewModule("Skins.Character");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(CharacterFrame)
        SUI:Skin(CharacterFrame.NineSlice)
        SUI:Skin(CharacterFrameInset)
        SUI:Skin(CharacterFrameInset.NineSlice)
        SUI:Skin(CharacterFrameInsetRight)
        SUI:Skin(CharacterFrameInsetRight.NineSlice)
        SUI:Skin(TokenFramePopup)
        SUI:Skin(TokenFramePopup.Border)
        SUI:Skin(CharacterStatsPane)
        SUI:Skin(ReputationFrame.ReputationDetailFrame)
        SUI:Skin({
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
            _G.select(CharacterSecondaryHandSlot:GetNumRegions(), CharacterSecondaryHandSlot:GetRegions()),
            PaperDollInnerBorderLeft,
            PaperDollInnerBorderRight,
            PaperDollInnerBorderTop,
            PaperDollInnerBorderTopLeft,
            PaperDollInnerBorderTopRight,
            PaperDollInnerBorderBottom,
            PaperDollInnerBorderBottomLeft,
            PaperDollInnerBorderBottomRight,
            PaperDollInnerBorderBottom2
        }, false, true)

        -- Tabs
        SUI:Skin(CharacterFrameTab1)
        SUI:Skin(CharacterFrameTab2)
        SUI:Skin(CharacterFrameTab3)

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_ItemSocketingUI" then
                SUI:Skin(ItemSocketingFrame)
                SUI:Skin(ItemSocketingFrame.NineSlice)
            end
        end)
    end
end
