local ADDON, SUI = ...
SUI.MODULES.UNITFRAMES.Party = function(state) 
    if (state) then
        hooksecurefunc("PlayerFrame_UpdateStatus",function()
     
            PlayerStatusTexture:Hide()
            PlayerRestGlow:Hide()
            PlayerStatusGlow:Hide()
     
            PlayerPrestigeBadge:SetAlpha(0)
            PlayerPrestigePortrait:SetAlpha(0)
            TargetFrameTextureFramePrestigeBadge:SetAlpha(0)
            TargetFrameTextureFramePrestigePortrait:SetAlpha(0)
            FocusFrameTextureFramePrestigeBadge:SetAlpha(0)
            FocusFrameTextureFramePrestigePortrait:SetAlpha(0)
    
        end)

        hooksecurefunc('TargetFrame_CheckFaction', function(self)
            self.nameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.5);
        end)
    end
end