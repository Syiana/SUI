local Module = SUI:NewModule("Skins.Achievment");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_AchievementUI" then
                for i, v in pairs({
                    AchievementFrameHeaderRight,
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
                    AchievementFrameMetalBorderTopRight,
                    AchievementFrameTab1.Left,
                    AchievementFrameTab1.Middle,
                    AchievementFrameTab1.Right,
                    AchievementFrameTab1.LeftHighlight,
                    AchievementFrameTab1.MiddleHighlight,
                    AchievementFrameTab1.RightHighlight,
                    AchievementFrameTab1.LeftActive,
                    AchievementFrameTab1.MiddleActive,
                    AchievementFrameTab1.RightActive,
                    AchievementFrameTab2.Left,
                    AchievementFrameTab2.Middle,
                    AchievementFrameTab2.Right,
                    AchievementFrameTab2.LeftHighlight,
                    AchievementFrameTab2.MiddleHighlight,
                    AchievementFrameTab2.RightHighlight,
                    AchievementFrameTab2.LeftActive,
                    AchievementFrameTab2.MiddleActive,
                    AchievementFrameTab2.RightActive,
                    AchievementFrameTab3.Left,
                    AchievementFrameTab3.Middle,
                    AchievementFrameTab3.Right,
                    AchievementFrameTab3.LeftHighlight,
                    AchievementFrameTab3.MiddleHighlight,
                    AchievementFrameTab3.RightHighlight,
                    AchievementFrameTab3.LeftActive,
                    AchievementFrameTab3.MiddleActive,
                    AchievementFrameTab3.RightActive
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
        end)
    end
end
