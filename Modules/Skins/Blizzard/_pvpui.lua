local Module = SUI:NewModule("Skins.PvPUI");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_PVPUI" then
                SUI:Skin(HonorFrame, true)
                SUI:Skin(HonorFrame.ConquestFrame, true)
                SUI:Skin(HonorFrame.Inset, true)
                SUI:Skin(HonorFrame.Inset.NineSlice, true)
                SUI:Skin(HonorFrame.BonusFrame, true)
                SUI:Skin(ConquestFrame, true)
                SUI:Skin(ConquestFrame.ConquestBar, true)
                SUI:Skin(ConquestFrame.Inset, true)
                SUI:Skin(ConquestFrame.Inset.NineSlice, true)
                SUI:Skin(PVPQueueFrame, true)
                SUI:Skin(PVPQueueFrame.HonorInset, true)
                SUI:Skin(PVPQueueFrame.HonorInset.NineSlice, true)
                PVPQueueFrame.HonorInset:Hide();
            end
        end)
    end
end
