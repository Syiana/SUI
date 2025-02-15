local Module = SUI:NewModule("Skins.Garrison");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_GarrisonUI" then
                SUI:Skin(GarrisonCapacitiveDisplayFrame, true)
                SUI:Skin(GarrisonCapacitiveDisplayFrame.NineSlice, true)
                SUI:Skin(GarrisonCapacitiveDisplayFrameInset, true)
                SUI:Skin(GarrisonCapacitiveDisplayFrameInset.NineSlice, true)
            end
        end)
    end
end
