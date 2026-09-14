local Module = SUI:NewModule("Skins.Professions");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Professions" then
                SUI:Skin(ProfessionsFrame, true)
                SUI:Skin(ProfessionsFrame.NineSlice, true)
                SUI:Skin(ProfessionsFrame.CraftingPage.RecipeList.BackgroundNineSlice, true)
                SUI:Skin(ProfessionsFrame.CraftingPage.SchematicForm.NineSlice, true)
                SUI:Skin(ProfessionsFrame.CraftingPage.SchematicForm.Details, true)
                SUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.OrderList.NineSlice, true)
                SUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList.BackgroundNineSlice, true)

                -- Tabs
                SUI:Skin(ProfessionsFrame.TabSystem.tabs[1], true)
                SUI:Skin(ProfessionsFrame.TabSystem.tabs[2], true)
                SUI:Skin(ProfessionsFrame.TabSystem.tabs[3], true)
                SUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.PublicOrdersButton, true)
                SUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.GuildOrdersButton, true)
                SUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.NpcOrdersButton, true)
                SUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.PersonalOrdersButton, true)
            end
        end)
    end
end
