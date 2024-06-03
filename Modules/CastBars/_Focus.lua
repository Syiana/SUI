local Module = SUI:NewModule("CastBars.Focus");

function Module:OnEnable()
  local db = SUI.db.profile.castbars
  if (db.style == 'Custom') then
    if not InCombatLockdown() then
      FocusFrameSpellBar:SetStatusBarTexture("Interface\\Addons\\SUI\\Media\\Textures\\Unitframes\\UI-StatusBar")
    end
  end
end