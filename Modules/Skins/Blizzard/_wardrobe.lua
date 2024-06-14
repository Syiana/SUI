local Module = SUI:NewModule("Skins.Wardrobe");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Collections" then
                SUI:Skin(WardrobeFrame)
                SUI:Skin(WardrobeTransmogFrame)
            end
        end)
    end
end