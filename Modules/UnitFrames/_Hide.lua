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
      PlayerPVPIcon:SetAlpha(0)
      TargetFrameTextureFramePVPIcon:SetAlpha(0)
    end
  end)

  hooksecurefunc('TargetFrame_CheckFaction', function(self)
    self.nameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.5);
  end)
end