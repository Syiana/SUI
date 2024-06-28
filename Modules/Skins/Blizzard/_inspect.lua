local Module = SUI:NewModule("Skins.Inspect");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_InspectUI" then
                SUI:Skin(InspectFrame)
                SUI:Skin(InspectPaperDollItemsFrame)
                SUI:Skin(InspectPaperDollFrame)
                SUI:Skin(InspectHeadSlot)
                SUI:Skin(InspectNeckSlot)
                SUI:Skin(InspectShoulderSlot)
                SUI:Skin(InspectBackSlot)
                SUI:Skin(InspectChestSlot)
                SUI:Skin(InspectShirtSlot)
                SUI:Skin(InspectTabardSlot)
                SUI:Skin(InspectWristSlot)
                SUI:Skin(InspectHandsSlot)
                SUI:Skin(InspectWaistSlot)
                SUI:Skin(InspectLegsSlot)
                SUI:Skin(InspectFeetSlot)
                SUI:Skin(InspectFinger0Slot)
                SUI:Skin(InspectFinger1Slot)
                SUI:Skin(InspectTrinket0Slot)
                SUI:Skin(InspectTrinket1Slot)
                SUI:Skin(InspectMainHandSlot)
                SUI:Skin(InspectSecondaryHandSlot)
                SUI:Skin(InspectRangedSlot)
                SUI:Skin(InspectPVPFrame)
                SUI:Skin(InspectPVPTeam1)
                SUI:Skin(InspectPVPTeam2)
                SUI:Skin(InspectPVPTeam3)
                SUI:Skin(InspectTalentFrame)
                SUI:Skin(InspectTalentFrameTab1)
                SUI:Skin(InspectTalentFrameTab2)
                SUI:Skin(InspectTalentFrameTab3)
                if (InspectTalentFrameTab4) then
                    SUI:Skin(InspectTalentFrameTab4)
                end
                SUI:Skin(InspectTalentFramePointsBar)
                SUI:Skin(InspectFrameTab1)
                SUI:Skin(InspectFrameTab2)
                SUI:Skin(InspectFrameTab3)
            end
        end)
    end
end
