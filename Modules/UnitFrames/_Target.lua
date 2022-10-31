local Module = SUI:NewModule("UnitFrames.Target");

function Module:OnEnable()

  function TestUpdate(self, auraList, numAuras, numOppositeAuras, setupFunc, anchorFunc, maxRowWidth, offsetX, mirrorAurasVertically)
    
      local hooked = {}
      local function UpdateTargetAuras(pool)
        for frame, _ in pairs(pool.activeObjects) do
          if not hooked[frame] then
              hooked[frame] = true

              local icon = frame.Icon
              icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
              icon:SetDrawLayer("BACKGROUND",-8)
              frame.icon = icon

              if not frame.border then
                local border = frame.border or 
                              frame:CreateTexture(frame.border, "BACKGROUND", nil, -7)

                border:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss")
                border:SetTexCoord(0, 1, 0, 1)
                border:SetDrawLayer("BACKGROUND",- 7)
                border:ClearAllPoints()
                border:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
                border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
                frame.border = border

                local backdrop = {
                  bgFile = nil,
                  edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
                  tile = false,
                  tileSize = 32,
                  edgeSize = 4,
                  insets = {
                    left = 4,
                    right = 4,
                    top = 4,
                    bottom = 4,
                  },
                }
                local back = CreateFrame("Frame", nil, frame, "BackdropTemplate")
                back:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, 4)
                back:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -4)
                back:SetFrameLevel(frame:GetFrameLevel() - 1)
                back:SetBackdrop(backdrop)
                back:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))
                frame.bg = back
              end
          end
        end
      end
    
      for poolKey, pool in pairs(TargetFrame.auraPools.pools) do
          hooksecurefunc(pool, "Acquire", UpdateTargetAuras)
      end

      for poolKey, pool in pairs(FocusFrame.auraPools.pools) do
        hooksecurefunc(pool, "Acquire", UpdateTargetAuras)
      end

  end

  local function SUIColorRepBar(self)
    local reputationBar = self.TargetFrameContent.TargetFrameContentMain.ReputationColor
    reputationBar:SetVertexColor(unpack(SUI:Color(0.15)))  
  end

  hooksecurefunc(TargetFrame, "UpdateAuraFrames", TestUpdate)
  hooksecurefunc(TargetFrame, "OnLoad", TestUpdate)

  hooksecurefunc(FocusFrame, "UpdateAuraFrames", TestUpdate)

  -- On Update Target Frame
  hooksecurefunc(TargetFrame, "Update", SUIColorRepBar)

  -- On Update Focus Frame
  hooksecurefunc(FocusFrame, "Update", SUIColorRepBar)
end









--[[local Module = SUI:NewModule("UnitFrames.Target");

function Module:OnEnable()
  local db = {
    unitframes = SUI.db.profile.unitframes,
    texture = SUI.db.profile.general.texture
  }

  if (db.unitframes) then
    local function SUITargetFrame (self, forceNormalTexture)
      if (db.unitframes.style == 'Big') then
          local classification = UnitClassification(self.unit);
          self.highLevelTexture:SetPoint("CENTER", self.levelText, "CENTER", 0,0);
          self.deadText:SetPoint("CENTER", self.healthbar, "CENTER",0,0);
          self.nameBackground:Hide();
          self.threatIndicator:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash");
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
          if TargetFrame.threatNumericIndicator:IsShown() then
            TargetFrame.threatNumericIndicator:SetPoint("BOTTOM", PlayerFrame, "TOP", 72, -21);
          end
          FocusFrame.threatNumericIndicator:SetAlpha(0);
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
              if ( self.threatIndicator ) then
                  if ( classification == "minus" ) then
                      self.threatIndicator:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Minus-Flash");
                      self.threatIndicator:SetTexCoord(0, 1, 0, 1);
                      self.threatIndicator:SetWidth(256);
                      self.threatIndicator:SetHeight(128);
                      self.threatIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", -24, 0);
                  else
                      self.threatIndicator:SetTexCoord(0, 0.9453125, 0, 0.181640625);
                      self.threatIndicator:SetWidth(242);
                      self.threatIndicator:SetHeight(93);
                      self.threatIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", -24, 0);
                  end
              end
          else
              self.haveElite = true;
              self.Background:SetSize(119,42);
              if ( self.threatIndicator ) then
                  self.threatIndicator:SetTexCoord(0, 0.9453125, 0.181640625, 0.400390625);
                  self.threatIndicator:SetWidth(242);
                  self.threatIndicator:SetHeight(112);
              end
          end
          self.healthbar.lockColor = true;
      end

      if (db.texture ~= 'Default') then
        self.healthbar:SetStatusBarTexture(db.texture);
        TargetFrameMyHealPredictionBar:SetTexture(db.texture);
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
]]