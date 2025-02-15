local Module = SUI:NewModule("Skins.Achievment");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_AchievementUI" then
                SUI:Skin(AchievementFrame)
                SUI:Skin(AchievementFrame.Header)
                SUI:Skin(AchievementFrame.Searchbox)
                SUI:Skin(AchievementFrameSummary)
                SUI:Skin(AchievementFrameTab1)
                SUI:Skin(AchievementFrameTab2)
                SUI:Skin(AchievementFrameTab3)
                AchievementFrame.Header.PointBorder:SetAlpha(0)
            end
        end)
    end
end
