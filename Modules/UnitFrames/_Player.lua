local Module = SUI:NewModule("UnitFrames.Player");

function Module:OnEnable()
  local db = {
    unitframes = SUI.db.profile.unitframes,
    texture = SUI.db.profile.general.texture
  }

  local Size = CreateFrame("Frame")
  Size:RegisterEvent("ADDON_LOADED")
  Size:RegisterEvent("PLAYER_LOGIN")
  Size:RegisterEvent("PLAYER_ENTERING_WORLD")
  Size:RegisterEvent("VARIABLES_LOADED")
  Size:SetScript("OnEvent", function()
    PlayerFrame:SetScale(db.unitframes.size)
  end)

  local statusTexture = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture;

  hooksecurefunc("PlayerFrame_UpdateStatus", function(self)
    if (IsResting()) then
      statusTexture:Hide()
    end
  end)
end