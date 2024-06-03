local Module = SUI:NewModule("UnitFrames.Textures");

function Module:OnEnable()
  local db = {
    texture = SUI.db.profile.general.texture
  }

  if (db.texture ~= 'Default') then
    function SUIManaTexture (manaBar)
      local powerType, powerToken, altR, altG, altB = UnitPowerType(manaBar.unit);
      local info = PowerBarColor[powerToken];
      if ( info ) then
        if ( not manaBar.lockColor ) then
          if not ( info.atlas ) then
            manaBar:SetStatusBarTexture(db.texture);
          end
        end
      end
    end
    hooksecurefunc("UnitFrameManaBar_UpdateType", SUIManaTexture)
  end
end