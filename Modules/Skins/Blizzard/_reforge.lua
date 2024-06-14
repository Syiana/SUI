local Module = SUI:NewModule("Skins.Reforge");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_ReforgingUI" then
                SUI:Skin(ReforgingFrame)
                SUI:Skin(ReforgingFrameRestoreButton)
                SUI:Skin(ReforgingFrameReforgeButton)
                SUI:Skin(ReforgingFrameButtonFrame)
            end
        end)
    end
end
