local Module = SUI:NewModule("Skins.Character");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(CharacterFrame)
        SUI:Skin(CharacterFrameInset)
        SUI:Skin(PaperDollItemsFrame)
        SUI:Skin(CharacterHeadSlot)
        SUI:Skin(CharacterNeckSlot)
        SUI:Skin(CharacterShoulderSlot)
        SUI:Skin(CharacterBackSlot)
        SUI:Skin(CharacterChestSlot)
        SUI:Skin(CharacterShirtSlot)
        SUI:Skin(CharacterTabardSlot)
        SUI:Skin(CharacterWristSlot)
        SUI:Skin(CharacterHandsSlot)
        SUI:Skin(CharacterWaistSlot)
        SUI:Skin(CharacterLegsSlot)
        SUI:Skin(CharacterFeetSlot)
        SUI:Skin(CharacterFinger0Slot)
        SUI:Skin(CharacterFinger1Slot)
        SUI:Skin(CharacterTrinket0Slot)
        SUI:Skin(CharacterTrinket1Slot)
        SUI:Skin(CharacterMainHandSlot)
        SUI:Skin(CharacterSecondaryHandSlot)
        SUI:Skin(CharacterRangedSlot)
        SUI:Skin(CharacterStatsPane.ScrollBar.Track)
        SUI:Skin(CharacterFrameInsetRight)
        SUI:Skin(CharacterFrameTab1)
        SUI:Skin(CharacterFrameTab3)
        SUI:Skin(CharacterFrameTab4)
        SUI:Skin(ReputationListScrollFrame)
        SUI:Skin({
            PaperDollInnerBorderTop,
            PaperDollInnerBorderLeft,
            PaperDollInnerBorderRight,
            PaperDollInnerBorderBottom,
            PaperDollInnerBorderBottom2,
            PaperDollInnerBorderTopLeft,
            PaperDollInnerBorderTopRight,
            PaperDollInnerBorderBottomLeft,
            PaperDollInnerBorderBottomRight
        }, false, true)

        CharacterFrame:HookScript("OnUpdate", function()
            SUI:Skin({
                CharacterHeadSlotNormalTexture,
                CharacterNeckSlotNormalTexture,
                CharacterShoulderSlotNormalTexture,
                CharacterBackSlotNormalTexture,
                CharacterChestSlotNormalTexture,
                CharacterShirtSlotNormalTexture,
                CharacterTabardSlotNormalTexture,
                CharacterWristSlotNormalTexture,
                CharacterHandsSlotNormalTexture,
                CharacterWaistSlotNormalTexture,
                CharacterLegsSlotNormalTexture,
                CharacterFeetSlotNormalTexture,
                CharacterFinger0SlotNormalTexture,
                CharacterFinger1SlotNormalTexture,
                CharacterTrinket0SlotNormalTexture,
                CharacterTrinket1SlotNormalTexture,
                CharacterMainHandSlotNormalTexture,
                CharacterSecondaryHandSlotNormalTexture,
                CharacterRangedSlotNormalTexture
            }, false, true)
        end)

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_ItemSocketingUI" then
                SUI:Skin(ItemSocketingFrame)
                SUI:Skin(ItemSocketingSocketButton)
            end
        end)
    end
end
