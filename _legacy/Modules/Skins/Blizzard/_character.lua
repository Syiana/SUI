local Module = SUI:NewModule("Skins.Character");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(CharacterFrame, true)
        SUI:Skin(CharacterFrame.NineSlice, true)
        SUI:Skin(CharacterFrameInset, true)
        SUI:Skin(CharacterFrameInset.NineSlice, true)
        SUI:Skin(CharacterFrameInsetRight, true)
        SUI:Skin(CharacterFrameInsetRight.NineSlice, true)
        SUI:Skin(TokenFramePopup, true)
        SUI:Skin(TokenFramePopup.Border, true)
        SUI:Skin(CharacterStatsPane, true)
        SUI:Skin(ReputationFrame.ReputationDetailFrame, true)
        SUI:Skin(ReputationFrame.ReputationDetailFrame.Border, true)
        SUI:Skin(CurrencyTransferLog, true)
        SUI:Skin(CurrencyTransferLog.TitleContainer, true)
        SUI:Skin(CurrencyTransferLog.NineSlice, true)
        SUI:Skin(CurrencyTransferLogInset.NineSlice, true)
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
        }, true, true)

        -- Tabs
        SUI:Skin(CharacterFrameTab1, true)
        SUI:Skin(CharacterFrameTab2, true)
        SUI:Skin(CharacterFrameTab3, true)

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_ItemSocketingUI" then
                SUI:Skin(ItemSocketingFrame, true)
                SUI:Skin(ItemSocketingFrame.NineSlice, true)
            end
        end)
    end
end
