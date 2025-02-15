local Module = SUI:NewModule("Skins.PvPUI");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_PVPUI" then
                SUI:Skin(HonorFrame)
                SUI:Skin(HonorFrame.ConquestFrame)
                SUI:Skin(HonorFrame.Inset)
                SUI:Skin(HonorFrame.Inset.NineSlice)
                SUI:Skin(HonorFrame.BonusFrame)
                SUI:Skin(ConquestFrame)
                SUI:Skin(ConquestFrame.ConquestBar)
                SUI:Skin(ConquestFrame.Inset)
                SUI:Skin(ConquestFrame.Inset.NineSlice)
                SUI:Skin(PVPQueueFrame)
                SUI:Skin(PVPQueueFrame.HonorInset)
                SUI:Skin(PVPQueueFrame.HonorInset.NineSlice)
                PVPQueueFrame.HonorInset:Hide();
            end
        end)
    end
end
