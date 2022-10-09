local Module = SUI:NewModule("UnitFrames.Player");

function Module:OnEnable()
  local db = {
    unitframes = SUI.db.profile.unitframes,
    texture = SUI.db.profile.general.texture
  }

  if (db.unitframes) then
    local function SUIPlayerFrame(self)

      local fontSize = db.unitframes.font.size
      self.healthbar.LeftText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
      self.healthbar.RightText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
      self.manabar.LeftText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
      self.manabar.RightText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")

      if (db.texture ~= 'Default') then
        self.healthbar:SetStatusBarTexture(db.texture);
      end

      if (db.unitframes.style == "Big") then
        PlayerFrameTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-TargetingFrame");
        self.name:Hide();
        self.name:ClearAllPoints();
        self.name:SetPoint("CENTER", PlayerFrame, "CENTER",50.5, 36);
        self.healthbar:SetPoint("TOPLEFT",106,-24);
        self.healthbar:SetHeight(26);
        self.healthbar.LeftText:ClearAllPoints();
        self.healthbar.LeftText:SetPoint("LEFT",self.healthbar,"LEFT",8,0);
        self.healthbar.RightText:ClearAllPoints();
        self.healthbar.RightText:SetPoint("RIGHT",self.healthbar,"RIGHT",-5,0);
        self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0);
        self.manabar:SetPoint("TOPLEFT",106,-52);
        self.manabar:SetHeight(13);
        self.manabar.LeftText:ClearAllPoints();
        self.manabar.LeftText:SetPoint("LEFT",self.manabar,"LEFT",8,0)		;
        self.manabar.RightText:ClearAllPoints();
        self.manabar.RightText:SetPoint("RIGHT",self.manabar,"RIGHT",-5,0);
        self.manabar.TextString:SetPoint("CENTER",self.manabar,"CENTER",0,0);
        --self.manabar.FullPowerFrame.SpikeFrame.AlertSpikeStay:ClearAllPoints();
        --self.manabar.FullPowerFrame.SpikeFrame.AlertSpikeStay:SetPoint("CENTER", self.manabar.FullPowerFrame, "RIGHT", -6, -3);
        --self.manabar.FullPowerFrame.SpikeFrame.AlertSpikeStay:SetSize(30,29);
        --self.manabar.FullPowerFrame.PulseFrame:ClearAllPoints();
        --self.manabar.FullPowerFrame.PulseFrame:SetPoint("CENTER", self.manabar.FullPowerFrame,"CENTER",-6,-2);
        --self.manabar.FullPowerFrame.SpikeFrame.BigSpikeGlow:ClearAllPoints();
       -- self.manabar.FullPowerFrame.SpikeFrame.BigSpikeGlow:SetPoint("CENTER",self.manabar.FullPowerFrame,"RIGHT",5,-4);
        --self.manabar.FullPowerFrame.SpikeFrame.BigSpikeGlow:SetSize(30,50);
        PlayerFrameGroupIndicatorText:ClearAllPoints();
        PlayerFrameGroupIndicatorText:SetPoint("BOTTOMLEFT", PlayerFrame,"TOP",0,-20);
        PlayerFrameGroupIndicatorLeft:Hide();
        PlayerFrameGroupIndicatorMiddle:Hide();
        PlayerFrameGroupIndicatorRight:Hide();
      end

      if (db.unitframes.style == "Small") then
        hooksecurefunc('TargetFrame_CheckFaction', function(self)
          self.nameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.5);
        end)
      end
    end

    local Size = CreateFrame("Frame")
    Size:RegisterEvent("ADDON_LOADED")
    Size:SetScript("OnEvent", function()
      PlayerFrame:SetScale(db.unitframes.size)
    end)

    hooksecurefunc("PlayerFrame_ToPlayerArt", SUIPlayerFrame)
  end
end