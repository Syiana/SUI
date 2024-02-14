local Module = SUI:NewModule("UnitFrames.Hide");

function Module:OnEnable()
    local db = SUI.db.profile.unitframes
    hooksecurefunc("PlayerFrame_UpdateStatus", function()
        -- pvpbadge
        if not (db.pvpbadge) then
            PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge:SetAlpha(0)
            PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait:SetAlpha(0)
            TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:SetAlpha(0)
            TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:SetAlpha(0)
            FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:SetAlpha(0)
            FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:SetAlpha(0)
            if (PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PVPIcon) then
                PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PVPIcon:SetAlpha(0)
            end
            if (TargetFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon) then
                TargetFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon:SetAlpha(0)
            end
            if (FocusFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon) then
                FocusFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon:SetAlpha(0)
            end
        end
    end)
end
