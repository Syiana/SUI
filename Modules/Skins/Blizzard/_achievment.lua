local Module = SUI:NewModule("Skins.Bags");

function Module:OnEnable()
  local f = CreateFrame("Frame")
  f:RegisterEvent("ADDON_LOADED")
  f:SetScript("OnEvent", function(self, event, name)
    if name == "Blizzard_AchievementUI" then
      for i, v in pairs({ AchievementFrameHeaderRight,
        AchievementFrameHeaderLeft,
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