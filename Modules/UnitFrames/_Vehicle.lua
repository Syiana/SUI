local Module = SUI:NewModule("UnitFrames.Vehicle");

function Module:OnEnable()
    local db = SUI.db.profile.unitframes
    if (db.style == 'Big') then
      function SUIVehicleFrame(self, vehicleType)
        if ( vehicleType == "Natural" ) then
          PlayerFrameVehicleTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame-Organic");
          PlayerFrameFlash:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame-Organic-Flash");
          PlayerFrameFlash:SetTexCoord(-0.02, 1, 0.07, 0.86);
          self.healthbar:SetSize(103,12);
          self.healthbar:SetPoint("TOPLEFT",116,-41);
          self.manabar:SetSize(103,12);
          self.manabar:SetPoint("TOPLEFT",116,-52);
        else
          PlayerFrameVehicleTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame");
          PlayerFrameFlash:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame-Flash");
          PlayerFrameFlash:SetTexCoord(-0.02, 1, 0.07, 0.86);
          self.healthbar:SetSize(100,12);
          self.healthbar:SetPoint("TOPLEFT",119,-41);
          self.manabar:SetSize(100,12);
          self.manabar:SetPoint("TOPLEFT",119,-52);
        end
        PlayerName:SetPoint("CENTER",50,23);
        PlayerFrameBackground:SetWidth(114);
      end
      hooksecurefunc("PlayerFrame_ToVehicleArt", SUIVehicleFrame)
    end
end