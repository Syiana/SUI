local Module = SUI:NewModule("UnitFrames.Text");

function Module:OnEnable()
  local db = SUI.db.profile.unitframes.hitindicator
  if not (db) then
    PlayerFrameGroupIndicator:SetAlpha(0)
    PlayerHitIndicator:SetText(nil)
    PlayerHitIndicator.SetText = function() end
    PetHitIndicator:SetText(nil)
    PetHitIndicator.SetText = function() end
  end
end