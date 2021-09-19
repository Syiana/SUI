local Module = SUI:NewModule("Skins.Frames");

function Module:OnEnable()
    -- Actionbar
    for i, v in pairs(
      {
        MainMenuBarArtFrameBackground.BackgroundLarge,
        MainMenuBarArtFrameBackground.BackgroundSmall,
        StatusTrackingBarManager.SingleBarLarge,
        StatusTrackingBarManager.SingleBarSmall,
        SlidingActionBarTexture0,
        SlidingActionBarTexture1,
        MainMenuBarTexture0,
        MainMenuBarTexture1,
        MainMenuBarTexture2,
        MainMenuBarTexture3,
        MainMenuMaxLevelBar0,
        MainMenuMaxLevelBar1,
        MainMenuMaxLevelBar2,
        MainMenuMaxLevelBar3,
        MainMenuXPBarTextureLeftCap,
        MainMenuXPBarTextureRightCap,
        MainMenuXPBarTextureMid,
        ReputationWatchBarTexture0,
        ReputationWatchBarTexture1,
        ReputationWatchBarTexture2,
        ReputationWatchBarTexture3,
        ReputationXPBarTexture0,
        ReputationXPBarTexture1,
        ReputationXPBarTexture2,
        ReputationXPBarTexture3,
      }
    ) do
      v:SetVertexColor(unpack(color.secondary))
    end
    for i, v in pairs(
      {
        MainMenuBarArtFrame.LeftEndCap,
        MainMenuBarArtFrame.RightEndCap,
        StanceBarLeft,
        StanceBarMiddle,
        StanceBarRight
      }
    ) do
      v:SetVertexColor(unpack(color.primary))
    end
    ActionBarUpButton:GetRegions():SetVertexColor(unpack(color.primary))
    ActionBarDownButton:GetRegions():SetVertexColor(unpack(color.primary))
end