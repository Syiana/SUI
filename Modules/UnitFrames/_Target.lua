local Module = SUI:NewModule("UnitFrames.Target");

function Module:OnEnable()
  local db = {
    unitframes = SUI.db.profile.unitframes,
    texture = SUI.db.profile.general.texture
  }

  if (db.unitframes) then
    local function SUITargetFrame (self, forceNormalTexture)

      local fontSize = db.unitframes.font.size
      self.healthbar.LeftText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
      self.healthbar.RightText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
      self.manabar.LeftText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
      self.manabar.RightText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")

      if (db.unitframes.style == 'Big') then
          local classification = UnitClassification(self.unit);
          self.highLevelTexture:SetPoint("CENTER", self.levelText, "CENTER", 0,0);
          self.deadText:SetPoint("CENTER", self.healthbar, "CENTER",0,0);
          self.nameBackground:Hide();
          self.name:SetPoint("LEFT", self, 15, 36);
          self.healthbar:SetSize(119, 26);
          self.healthbar:SetPoint("TOPLEFT", 5, -24);
          self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 8, 0);
          self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -5, 0);
          self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0);
          self.manabar:SetPoint("TOPLEFT", 5, -52);
          self.manabar:SetSize(119, 13);
          self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 8, 0);
          self.manabar.RightText:ClearAllPoints();
          self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -5, 0);
          self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 0);
          if (forceNormalTexture) then
            self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame");
          elseif ( classification == "minus" ) then
              self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Minus");
            forceNormalTexture = true;
          elseif ( classification == "worldboss" or classification == "elite" ) then
            self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-TargetingFrame-Elite");
          elseif ( classification == "rareelite" ) then
            self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-TargetingFrame-Rare-Elite");
          elseif ( classification == "rare" ) then
            self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-TargetingFrame-Rare");
          else
            self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-TargetingFrame");
            forceNormalTexture = true;
          end
          if (forceNormalTexture) then
              self.haveElite = nil;
              if (classification == "minus") then
                self.Background:SetSize(119,12);
                self.Background:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 7, 47);
                self.name:SetPoint("LEFT", self, 16, 19);
                self.healthbar:ClearAllPoints();
                self.healthbar:SetPoint("LEFT", 5, 3);
                self.healthbar:SetHeight(12);
                self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 3, 0);
                self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -2, 0);
              else
                self.Background:SetSize(119,42);
                self.Background:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 7, 35);
              end
          else
              self.haveElite = true;
              self.Background:SetSize(119,42);
          end
          self.healthbar.lockColor = true;
      end

      if (db.texture ~= 'Default') then
        self.healthbar:SetStatusBarTexture(db.texture);
        --TargetFrameMyHealPredictionBar:SetTexture(db.texture);
      end
    end

    local function SUIToTFrame()
      --textures
      if (db.texture ~= 'Default') then
        TargetFrameToTHealthBar:SetStatusBarTexture(db.texture);
        TargetFrameToTManaBar:SetStatusBarTexture(db.texture);
      end

      TargetFrameToTTextureFrameDeadText:ClearAllPoints();
      TargetFrameToTTextureFrameDeadText:SetPoint("CENTER", "TargetFrameToTHealthBar","CENTER",1, 0);
      TargetFrameToTTextureFrameName:SetSize(65,10);
      TargetFrameToTTextureFrameTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\unitframes\\UI-TargetofTargetFrame");
      TargetFrameToTHealthBar:ClearAllPoints();
      TargetFrameToTHealthBar:SetPoint("TOPLEFT", 45, -15);
      TargetFrameToTHealthBar:SetHeight(10);
      TargetFrameToTManaBar:ClearAllPoints();
      TargetFrameToTManaBar:SetPoint("TOPLEFT", 45, -25);
      TargetFrameToTManaBar:SetHeight(5);
      FocusFrameToTTextureFrameDeadText:ClearAllPoints();
      FocusFrameToTTextureFrameDeadText:SetPoint("CENTER", "FocusFrameToTHealthBar" ,"CENTER",1, 0);
      FocusFrameToTTextureFrameName:SetSize(65,10);
      FocusFrameToTTextureFrameTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\unitframes\\UI-TargetofTargetFrame");
      FocusFrameToTHealthBar:ClearAllPoints();
      FocusFrameToTHealthBar:SetPoint("TOPLEFT", 43, -15);
      FocusFrameToTHealthBar:SetHeight(10);
      FocusFrameToTManaBar:ClearAllPoints();
      FocusFrameToTManaBar:SetPoint("TOPLEFT", 43, -25);
      FocusFrameToTManaBar:SetHeight(5);
    end

    local Size = CreateFrame("Frame")
    Size:RegisterEvent("ADDON_LOADED")
    Size:SetScript("OnEvent", function()
      TargetFrame:SetScale(db.unitframes.size)
      FocusFrame:SetScale(db.unitframes.size)
    end)

    hooksecurefunc("TargetFrame_CheckClassification", SUITargetFrame)
    hooksecurefunc("TargetFrame_CheckClassification", SUIToTFrame)
  end
end