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
        SUI:Skin(CharacterStatsPane.ScrollBar.Track.Thumb)
        SUI:Skin(CharacterFrameInsetRight)
        SUI:Skin(CharacterFrameTab1)
        SUI:Skin(CharacterFrameTab3)
        SUI:Skin(CharacterFrameTab4)
        SUI:Skin(ReputationListScrollFrame)

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
