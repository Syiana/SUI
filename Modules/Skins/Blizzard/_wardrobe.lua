local Module = SUI:NewModule("Skins.Wardrobe");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Collections" then
                SUI:Skin(WardrobeFrame)
                SUI:Skin(WardrobeTransmogFrame)
                SUI:Skin(WardrobeTransmogFrame.Inset)
                SUI:Skin(WardrobeTransmogFrame.ApplyButton)
                SUI:Skin(WardrobeCollectionFrameTab1)

                -- Buttons
                SUI:Skin({
                    WardrobeTransmogFrame.ApplyButton.Left,
                    WardrobeTransmogFrame.ApplyButton.Middle,
                    WardrobeTransmogFrame.ApplyButton.Right
                }, false, true, false, true)
            end
        end)
    end
end