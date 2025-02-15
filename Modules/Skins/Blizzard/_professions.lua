local Module = SUI:NewModule("Skins.Professions");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Professions" then
                SUI:Skin(ProfessionsFrame)
                SUI:Skin(ProfessionsFrame.NineSlice)

                -- Tabs
                SUI:Skin(ProfessionsFrame.TabSystem.tabs[1])
                SUI:Skin(ProfessionsFrame.TabSystem.tabs[2])
                SUI:Skin(ProfessionsFrame.TabSystem.tabs[3])
            end
        end)
    end
end
