local Module = SUI:NewModule("UnitFrames.Player");

function Module:OnEnable()
  local db = {
    unitframes = SUI.db.profile.unitframes,
    texture = SUI.db.profile.general.texture
  }
  
  local statusTexture = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture;
  local statusAnimation = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop

  hooksecurefunc("PlayerFrame_UpdateStatus", function(self)
    if (IsResting()) then
      statusTexture:Hide()
      statusAnimation:Hide()
    end
  end)
end