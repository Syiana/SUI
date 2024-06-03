local Module = SUI:NewModule("UnitFrames.Hide");

function Module:OnEnable()
  local db = SUI.db.profile.unitframes
  hooksecurefunc("PlayerFrame_UpdateStatus",function()
    -- statusglow
    if not (db.statusglow) then
      PlayerStatusTexture:Hide()
      PlayerRestGlow:Hide()
      PlayerStatusGlow:Hide()
    end
    -- pvpbadge
    if not (db.pvpbadge) then
      PlayerPrestigeBadge:SetAlpha(0)
      PlayerPrestigePortrait:SetAlpha(0)
      TargetFrameTextureFramePrestigeBadge:SetAlpha(0)
      TargetFrameTextureFramePrestigePortrait:SetAlpha(0)
      FocusFrameTextureFramePrestigeBadge:SetAlpha(0)
      FocusFrameTextureFramePrestigePortrait:SetAlpha(0)
    end
  end)

  hooksecurefunc('TargetFrame_CheckFaction', function(self)
    self.nameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.5);
  end)
end