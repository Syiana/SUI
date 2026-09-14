local Module = SUI:NewModule("Skins.Azerit");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_AzeriteUI" then
                SUI:Skin(AzeriteEmpoweredItemUI.BorderFrame, true)
                SUI:Skin(AzeriteEmpoweredItemUI.BorderFrame.NineSlice, true)
            end

            if name == "Blizzard_AzeriteRespecUI" then
                SUI:Skin(AzeriteRespecFrame, true)
                SUI:Skin(AzeriteRespecFrame.NineSlice, true)
            end

            if name == "Blizzard_AzeriteEssenceUI" then
                SUI:Skin(AzeriteEssenceUI, true)
                SUI:Skin(AzeriteEssenceUI.NineSlice, true)
                SUI:Skin(AzeriteEssenceUI.LeftInset.NineSlice, true)
                SUI:Skin(AzeriteEssenceUI.RightInset.NineSlice, true)
                SUI:Skin(AzeriteEssenceUI.EssenceList.ScrollBar, true)
            end
        end)
    end
end
