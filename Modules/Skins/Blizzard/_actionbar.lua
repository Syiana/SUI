local Module = SUI:NewModule("Skins.ActionBar");

function Module:OnEnable()
  for i, v in pairs({
    MainMenuBarArtFrameBackground.BackgroundLarge,
    MainMenuBarArtFrameBackground.BackgroundSmall,
    StatusTrackingBarManager.SingleBarLarge,
    StatusTrackingBarManager.SingleBarSmall,
    StatusTrackingBarManager.SingleBarLargeUpper,
    StatusTrackingBarManager.SingleBarSmallUpper,
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
  }) do
    v:SetVertexColor(unpack(SUI:Color(0.15)))
  end
  for i, v in pairs({
    MainMenuBarArtFrame.LeftEndCap,
    MainMenuBarArtFrame.RightEndCap,
    StanceBarLeft,
    StanceBarMiddle,
    StanceBarRight,
    ActionBarUpButton:GetRegions(),
    ActionBarDownButton:GetRegions()
  }) do
    v:SetVertexColor(unpack(SUI:Color()))
  end
end