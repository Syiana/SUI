local Module = SUI:NewModule("Skins.ScrappingMachine");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_ScrappingMachineUI" then
                SUI:Skin(ScrappingMachineFrame)
                SUI:Skin(ScrappingMachineFrame.NineSlice)
            end
        end)
    end
end
