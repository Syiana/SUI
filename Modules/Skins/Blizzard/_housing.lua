local Module = SUI:NewModule("Skins.Housing");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_HousingDashboard" then
                SUI:Skin(HousingDashboardFrame, true)
                SUI:Skin(HousingDashboardFrame.NineSlice, true)
                SUI:Skin({
                    HousingDashboardFrameScrollFrameScrollBarBottom,
                    HousingDashboardFrameScrollFrameScrollBarMiddle,
                    HousingDashboardFrameScrollFrameScrollBarTop,
                    HousingDashboardFrameScrollFrameScrollBarThumbTexture
                }, true, true)
            end
        end)
    end
end
