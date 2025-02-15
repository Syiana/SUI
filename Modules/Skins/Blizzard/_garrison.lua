local Module = SUI:NewModule("Skins.Garrison");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_GarrisonUI" then
                SUI:Skin(GarrisonCapacitiveDisplayFrame)
                SUI:Skin(GarrisonCapacitiveDisplayFrame.NineSlice)
                SUI:Skin(GarrisonCapacitiveDisplayFrameInset)
                SUI:Skin(GarrisonCapacitiveDisplayFrameInset.NineSlice)
            end
        end)
    end
end
