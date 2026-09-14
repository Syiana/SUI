local Module = SUI:NewModule("Skins.FlightMap");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_FlightMap" then
                SUI:Skin(FlightMapFrame, true)
                SUI:Skin(FlightMapFrame.BorderFrame, true)
                SUI:Skin(FlightMapFrame.BorderFrame.NineSlice, true)
            end
        end)
    end
end
