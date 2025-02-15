local Module = SUI:NewModule("Skins.Achievment");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_AchievementUI" then
                SUI:Skin(AchievementFrame, true)
                SUI:Skin(AchievementFrame.Header, true)
                SUI:Skin(AchievementFrame.Searchbox, true)
                SUI:Skin(AchievementFrameSummary, true)
                SUI:Skin(AchievementFrameTab1, true)
                SUI:Skin(AchievementFrameTab2, true)
                SUI:Skin(AchievementFrameTab3, true)
                AchievementFrame.Header.PointBorder:SetAlpha(0)
                select(8, AchievementFrame.Header:GetRegions()):SetVertexColor(1, 1, 1)
            end
        end)
    end
end
