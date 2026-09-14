local Module = SUI:NewModule("Skins.Islands");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_IslandsQueueUI" then
                SUI:Skin(IslandsQueueFrame, true)
                SUI:Skin(IslandsQueueFrame.NineSlice, true)
                SUI:Skin(IslandsQueueFrame.ArtOverlayFrame, true)
            end
        end)
    end
end
