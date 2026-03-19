local Module = SUI:NewModule("UnitFrames.Hide");

function Module:RefreshVisibility()
    local db = SUI.db.profile.unitframes
    local alpha = db.pvpbadge and 1 or 0
    local contextualFrames = {
        PlayerFrame and PlayerFrame.PlayerFrameContent and PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual,
        TargetFrame and TargetFrame.TargetFrameContent and TargetFrame.TargetFrameContent.TargetFrameContentContextual,
        FocusFrame and FocusFrame.TargetFrameContent and FocusFrame.TargetFrameContent.TargetFrameContentContextual
    }

    for _, frame in ipairs(contextualFrames) do
        if frame then
            if frame.PrestigeBadge then
                frame.PrestigeBadge:SetAlpha(alpha)
            end
            if frame.PrestigePortrait then
                frame.PrestigePortrait:SetAlpha(alpha)
            end
            if frame.PVPIcon then
                frame.PVPIcon:SetAlpha(alpha)
            end
            if frame.PvpIcon then
                frame.PvpIcon:SetAlpha(alpha)
            end
        end
    end
end

function Module:OnEnable()
    hooksecurefunc("PlayerFrame_UpdateStatus", function()
        Module:RefreshVisibility()
    end)

    Module:RefreshVisibility()
end
