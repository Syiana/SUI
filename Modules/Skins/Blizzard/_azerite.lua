local Module = SUI:NewModule("Skins.Azerit");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_AzeriteUI" then
                SUI:Skin(AzeriteEmpoweredItemUI.BorderFrame)
                SUI:Skin(AzeriteEmpoweredItemUI.BorderFrame.NineSlice)
            end

            if name == "Blizzard_AzeriteRespecUI" then
                SUI:Skin(AzeriteRespecFrame)
                SUI:Skin(AzeriteRespecFrame.NineSlice)
            end

            if name == "Blizzard_AzeriteEssenceUI" then
                SUI:Skin(AzeriteEssenceUI)
                SUI:Skin(AzeriteEssenceUI.NineSlice)
                SUI:Skin(AzeriteEssenceUI.LeftInset.NineSlice)
                SUI:Skin(AzeriteEssenceUI.RightInset.NineSlice)
                SUI:Skin(AzeriteEssenceUI.EssenceList.ScrollBar)
            end
        end)
    end
end
