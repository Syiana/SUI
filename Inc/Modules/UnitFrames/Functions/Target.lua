local ADDON, SUI = ...
SUI.MODULES.UNITFRAMES.Target = function(DB) 
    if (DB and DB.STATE) then
        function SUITargetFrame (self, forceNormalTexture)
            if (DB.CONFIG.BigFrames) then
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
                if ( forceNormalTexture ) then
                    self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame");
                elseif ( classification == "minus" ) then
                    self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Minus");
                    forceNormalTexture = true;
                elseif ( classification == "worldboss" or classification == "elite" ) then
                    self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Inc\\Assets\\Media\\UnitFrames\\UI-TargetingFrame-Elite");
                elseif ( classification == "rareelite" ) then
                    self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Inc\\Assets\\Media\\UnitFrames\\UI-TargetingFrame-Rare-Elite");
                elseif ( classification == "rare" ) then
                    self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Inc\\Assets\\Media\\UnitFrames\\UI-TargetingFrame-Rare");
                else
                    self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Inc\\Assets\\Media\\UnitFrames\\UI-TargetingFrame");
                    forceNormalTexture = true;
                end
                if ( forceNormalTexture ) then
                    self.haveElite = nil;
                    if ( classification == "minus" ) then
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
           
            self.healthbar:SetStatusBarTexture("Interface\\Addons\\SUI\\Inc\\Assets\\Media\\UnitFrames\\UI-StatusBar");
            TargetFrameMyHealPredictionBar:SetTexture("Interface\\Addons\\SUI\\Inc\\Assets\\Media\\UnitFrames\\UI-StatusBar");
            
        end
        hooksecurefunc("TargetFrame_CheckClassification", SUITargetFrame)

        function SUIToTFrame()
     
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\Addons\\SUI\\inc\\assets\\media\\unitframes\\UI-StatusBar");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\Addons\\SUI\\inc\\assets\\media\\unitframes\\UI-StatusBar");
       
            TargetFrameToTTextureFrameDeadText:ClearAllPoints();
            TargetFrameToTTextureFrameDeadText:SetPoint("CENTER", "TargetFrameToTHealthBar","CENTER",1, 0);
            TargetFrameToTTextureFrameName:SetSize(65,10);
            TargetFrameToTTextureFrameTexture:SetTexture("Interface\\Addons\\SUI\\inc\\assets\\media\\unitframes\\UI-TargetofTargetFrame");
            TargetFrameToTHealthBar:ClearAllPoints();
            TargetFrameToTHealthBar:SetPoint("TOPLEFT", 45, -15);
            TargetFrameToTHealthBar:SetHeight(10);
            TargetFrameToTManaBar:ClearAllPoints();
            TargetFrameToTManaBar:SetPoint("TOPLEFT", 45, -25);
            TargetFrameToTManaBar:SetHeight(5);
            FocusFrameToTTextureFrameDeadText:ClearAllPoints();
            FocusFrameToTTextureFrameDeadText:SetPoint("CENTER", "FocusFrameToTHealthBar" ,"CENTER",1, 0);
            FocusFrameToTTextureFrameName:SetSize(65,10);
            FocusFrameToTTextureFrameTexture:SetTexture("Interface\\Addons\\SUI\\inc\\assets\\media\\unitframes\\UI-TargetofTargetFrame");
            FocusFrameToTHealthBar:ClearAllPoints();
            FocusFrameToTHealthBar:SetPoint("TOPLEFT", 43, -15);
            FocusFrameToTHealthBar:SetHeight(10);
            FocusFrameToTManaBar:ClearAllPoints();
            FocusFrameToTManaBar:SetPoint("TOPLEFT", 43, -25);
            FocusFrameToTManaBar:SetHeight(5);
        end
        hooksecurefunc("TargetFrame_CheckClassification", SUIToTFrame)
    end
end