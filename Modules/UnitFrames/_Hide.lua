local Module = SUI:NewModule("UnitFrames.Hide");

function Module:OnEnable()
  local db = SUI.db.profile.unitframes
  hooksecurefunc("PlayerFrame_UpdateStatus",function()
    -- pvpbadge
    if not (db.pvpbadge) then
      PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge:SetAlpha(0)
      PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait:SetAlpha(0)
      TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:SetAlpha(0)
      TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:SetAlpha(0)
    end
  end)
end