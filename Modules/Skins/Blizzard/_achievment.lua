local Module = SUI:NewModule("Skins.Achievment");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_AchievementUI" then
                for i, v in pairs({ AchievementFrameHeaderRight,
                    AchievementFrame.Header.Left,
                    AchievementFrame.Header.Right,
                    AchievementFrame.Header.RightDDLInset,
                    AchievementFrame.Searchbox,
                    AchievementFrameSummary.Background,
                    AchievementFrameCategoriesBG,
                    AchievementFrame.Background,
                    AchievementFrameWoodBorderTopLeft,
                    AchievementFrameWoodBorderBottomLeft,
                    AchievementFrameWoodBorderTopRight,
                    AchievementFrameWoodBorderBottomRight,
                    AchievementFrameMetalBorderBottom,
                    AchievementFrameMetalBorderBottomLeft,
                    AchievementFrameMetalBorderBottomRight,
                    AchievementFrameMetalBorderLeft,
                    AchievementFrameMetalBorderRight,
                    AchievementFrameMetalBorderTop,
                    AchievementFrameMetalBorderTopLeft,
                    AchievementFrameMetalBorderTopRight, }) do
                    v:SetVertexColor(.15, .15, .15)
                end
            end
        end)
    end
end
