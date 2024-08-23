local Module = SUI:NewModule("Skins.ActionBar");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({
            MainMenuBar.BorderArt,
            StatusTrackingBarManager.SingleBarLarge,
            StatusTrackingBarManager.SingleBarSmall,
            StatusTrackingBarManager.SingleBarLargeUpper,
            StatusTrackingBarManager.SingleBarSmallUpper,
            SlidingActionBarTexture0,
            SlidingActionBarTexture1,
            ActionButton1.RightDivider,
            ActionButton2.RightDivider,
            ActionButton3.RightDivider,
            ActionButton4.RightDivider,
            ActionButton5.RightDivider,
            ActionButton6.RightDivider,
            ActionButton7.RightDivider,
            ActionButton8.RightDivider,
            ActionButton9.RightDivider,
            ActionButton10.RightDivider,
            ActionButton11.RightDivider,
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
            StatusTrackingBarManager.BottomBarFrameTexture,
            StatusTrackingBarManager.MainStatusTrackingBarContainer.BarFrameTexture,
            StatusTrackingBarManager.SecondaryStatusTrackingBarContainer.BarFrameTexture,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
            MainMenuBar.EndCaps.LeftEndCap,
            MainMenuBar.EndCaps.RightEndCap,
            StanceBarLeft,
            StanceBarMiddle,
            StanceBarRight,
        }) do
            v:SetDesaturated(true)
            v:SetVertexColor(unpack(SUI:Color()))
        end

        for i, v in pairs({
            MainMenuBar.ActionBarPageNumber.UpButton:GetRegions()
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.2)))
        end

        for i, v in pairs({
            MainMenuBar.ActionBarPageNumber:GetRegions(),
        }) do
            v:SetVertexColor(unpack(SUI:Color()))
        end

        for i, v in pairs({
            MainMenuBar.ActionBarPageNumber.DownButton:GetRegions()
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.2)))
        end

        for _,v in pairs({MainMenuBar:GetChildren()}) do
            for _,v in pairs({v:GetRegions()}) do
                v:SetVertexColor(unpack(SUI:Color(0.2)))
            end
        end
    end
end
