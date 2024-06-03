local Module = SUI:NewModule("UnitFrames.Pet");

function Module:OnEnable()
    local db = {
      unitframes = SUI.db.profile.unitframes,
      texture = SUI.db.profile.general.texture
    }
    if (db.texture ~= 'Default') then
      PetFrameHealthBar:SetStatusBarTexture(db.texture);
      PetFrameManaBar:SetStatusBarTexture(db.texture);
    end
    if (db.style == 'Big') then
      PetFrameHealthBar:ClearAllPoints()
      PetFrameHealthBar:SetPoint("TOPLEFT", 45, -22)
      PetFrameHealthBar:SetHeight(10)
      PetFrameManaBar:ClearAllPoints()
      PetFrameManaBar:SetPoint("TOPLEFT", 45, -32)
      PetFrameManaBar:SetHeight(5)
    end
end