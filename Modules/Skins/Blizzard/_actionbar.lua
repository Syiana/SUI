local Module = SUI:NewModule("Skins.ActionBar");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
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
	  MainMenuXPBarTexture0,
    MainMenuXPBarTexture1,
	  MainMenuXPBarTexture2,
	  MainMenuXPBarTexture3,
	  MainMenuXPBarTexture4,
	  ReputationWatchBar.StatusBar.WatchBarTexture0,
    ReputationWatchBar.StatusBar.WatchBarTexture1,
    ReputationWatchBar.StatusBar.WatchBarTexture2,
    ReputationWatchBar.StatusBar.WatchBarTexture3,
    }) do
      v:SetVertexColor(unpack(SUI:Color(0.15)))
    end
    for i, v in pairs({
      MainMenuBarLeftEndCap,
      MainMenuBarRightEndCap,
      StanceBarLeft,
      StanceBarMiddle,
      StanceBarRight,
    }) do
      v:SetVertexColor(unpack(SUI:Color()))
    end

    for i, v in pairs({
      ActionBarUpButton:GetRegions(),
    }) do
      v:SetVertexColor(unpack(SUI:Color()))
    end

    for i, v in pairs({
      ActionBarDownButton:GetRegions()
    }) do
      v:SetVertexColor(unpack(SUI:Color()))
    end

    if (SUI.db.profile.actionbar.style == 'Retail' or SUI.db.profile.actionbar.style == 'RetailTransparent') then
      if (SUI:Color()) then
        for i, v in pairs({
          RetailUIArtFrame.BackgroundLarge,
          RetailUIArtFrame.BackgroundSmall,
          MicroButtonAndBagsBarTexture,
          RetailUIStatusBars.SingleBarLarge,
          RetailUIStatusBars.SingleBarSmall,
        }) do
        v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
      end
    end
  end
end