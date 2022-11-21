local Module = SUI:NewModule("UnitFrames.Target");

function Module:OnEnable()

  local db = {
    unitframes = SUI.db.profile.unitframes,
    texture = SUI.db.profile.general.texture,
    theme = SUI.db.profile.general.theme
  }

  -- Powerbar Colors
  local PowerColor = {};
  PowerColor["MANA"] =				{ r = 0.00, g = 0.50, b = 1.00, atlasElementName="Mana" };
  PowerColor["RAGE"] =				{ r = 1.00, g = 0.00, b = 0.00, fullPowerAnim=true, atlasElementName="Rage" };
  PowerColor["FOCUS"] =			{ r = 1.00, g = 0.50, b = 0.25, fullPowerAnim=true, atlasElementName="Focus" };
  PowerColor["ENERGY"] =			{ r = 1.00, g = 1.00, b = 0.00, fullPowerAnim=true, atlasElementName="Energy" };
  PowerColor["COMBO_POINTS"] =		{ r = 1.00, g = 0.96, b = 0.41 };
  PowerColor["RUNES"] =			{ r = 0.50, g = 0.50, b = 0.50 };
  PowerColor["RUNIC_POWER"] =		{ r = 0.00, g = 0.82, b = 1.00, fullPowerAnim=true, atlasElementName="RunicPower" };
  PowerColor["SOUL_SHARDS"] =		{ r = 0.50, g = 0.32, b = 0.55 };
  PowerColor["LUNAR_POWER"] =		{ r = 0.30, g = 0.52, b = 0.90, atlas="_Druid-LunarBar" };
  PowerColor["HOLY_POWER"] =		{ r = 0.95, g = 0.90, b = 0.60 };
  PowerColor["MAELSTROM"] =		{ r = 0.00, g = 0.50, b = 1.00, atlas = "_Shaman-MaelstromBar", fullPowerAnim=true };
  PowerColor["INSANITY"] =			{ r = 0.40, g = 0.00, b = 0.80, atlas = "_Priest-InsanityBar"};
  PowerColor["CHI"] =				{ r = 0.71, g = 1.00, b = 0.92 };
  PowerColor["ARCANE_CHARGES"] =	{ r = 0.10, g = 0.10, b = 0.98 };
  PowerColor["FURY"] =				{ r = 0.788, g = 0.259, b = 0.992, atlas = "_DemonHunter-DemonicFuryBar", fullPowerAnim=true };
  PowerColor["PAIN"] =				{ r = 255/255, g = 156/255, b = 0, atlas = "_DemonHunter-DemonicPainBar", fullPowerAnim=true };
  PowerColor["AMMOSLOT"] = { r = 0.80, g = 0.60, b = 0.00 };
  PowerColor["FUEL"] = { r = 0.0, g = 0.55, b = 0.5 };
  PowerColor["STAGGER"] = { {r = 0.52, g = 1.0, b = 0.52}, {r = 1.0, g = 0.98, b = 0.72}, {r = 1.0, g = 0.42, b = 0.42},};
  PowerColor[0] = PowerColor["MANA"];
  PowerColor[1] = PowerColor["RAGE"];
  PowerColor[2] = PowerColor["FOCUS"];
  PowerColor[3] = PowerColor["ENERGY"];
  PowerColor[4] = PowerColor["CHI"];
  PowerColor[5] = PowerColor["RUNES"];
  PowerColor[6] = PowerColor["RUNIC_POWER"];
  PowerColor[7] = PowerColor["SOUL_SHARDS"];
  PowerColor[8] = PowerColor["LUNAR_POWER"];
  PowerColor[9] = PowerColor["HOLY_POWER"];
  PowerColor[11] = PowerColor["MAELSTROM"];
  PowerColor[13] = PowerColor["INSANITY"];
  PowerColor[17] = PowerColor["FURY"];
  PowerColor[18] = PowerColor["PAIN"];

  local function GetPowerColor(powerType)
    return PowerColor[powerType]
  end

  -- Set HealthBar Textures
  if db.texture ~= [[Interface\Default]] then
    TargetFrame:HookScript("OnEvent", function()
      local targetHealthBar = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar
      local targetManaBarTexture = TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.texture
      local targetManaBar = TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar
      local powerColor = GetPowerColor(targetManaBar.powerType)

      --TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar.AnimatedLossBar:SetStatusBarTexture(db.texture)
      --self.myHealPredictionBar:SetTexture(db.texture)
      --self.otherHealPredictionBar:SetTexture(db.texture)
      --self.myManaCostPredictionBar:SetTexture(db.texture)

      targetHealthBar:SetStatusBarTexture(db.texture)
      targetManaBarTexture:SetTexture(db.texture)
      targetManaBar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)

      TargetFrameToT.HealthBar:SetStatusBarTexture(db.texture)
      local totPowerColor = GetPowerColor(TargetFrameToT.ManaBar.powerType)
      TargetFrameToT.ManaBar:SetStatusBarTexture(db.texture)
      TargetFrameToT.ManaBar:SetStatusBarColor(totPowerColor.r, totPowerColor.g, totPowerColor.b) 
    end)

    FocusFrame:HookScript("OnEvent", function()
      local focusHealthBar = FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar
      local focusManaBarTexture = FocusFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.texture
      local focusManaBar = FocusFrame.TargetFrameContent.TargetFrameContentMain.ManaBar
      local powerColor = GetPowerColor(focusManaBar.powerType)

      focusHealthBar:SetStatusBarTexture(db.texture)
      focusManaBarTexture:SetTexture(db.texture)
      focusManaBar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)

      FocusFrameToT.HealthBar:SetStatusBarTexture(db.texture)
      local totPowerColor = GetPowerColor(FocusFrameToT.ManaBar.powerType)
      FocusFrameToT.ManaBar:SetStatusBarTexture(db.texture)
      FocusFrameToT.ManaBar:SetStatusBarColor(totPowerColor.r, totPowerColor.g, totPowerColor.b)
      FocusFrameToT.ManaBar:SetStatusBarTexture(db.texture)
    end)
  end

  local hooked = {}
  local function UpdateFrameAuras(pool)
    if db.theme ~= 'Blizzard' then
      for frame, _ in pairs(pool.activeObjects) do
        if not hooked[frame] then
          hooked[frame] = true

          local icon = frame.Icon
          icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
          icon:SetDrawLayer("BACKGROUND",-8)

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
  end

  for poolKey, pool in pairs(TargetFrame.auraPools.pools) do
    hooksecurefunc(pool, "Acquire", UpdateFrameAuras)
  end

  for poolKey, pool in pairs(FocusFrame.auraPools.pools) do
    hooksecurefunc(pool, "Acquire", UpdateFrameAuras)
  end

  local function SUIColorRepBar(self)
    if (SUI:Color()) then
      local reputationBar = self.TargetFrameContent.TargetFrameContentMain.ReputationColor
      reputationBar:SetVertexColor(unpack(SUI:Color(0.15)))  
    end
  end

  -- On Update Target Frame
  hooksecurefunc(TargetFrame, "Update", SUIColorRepBar)

  -- On Update Focus Frame
  hooksecurefunc(FocusFrame, "Update", SUIColorRepBar)

  -- Set TargetFrame Buff/Debuff SetSize
  hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(_, buff)
    buff:SetSize(db.unitframes.buffs.size, db.unitframes.buffs.size)

    if buff.Count then
      local fontSize = db.unitframes.buffs.size / 2.75
      buff.Count:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
      buff.Count:ClearAllPoints()
      buff.Count:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", 2, 0)
    end
  end)

  hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(_, debuff)
    debuff:SetSize(db.unitframes.debuffs.size, db.unitframes.debuffs.size)

    if debuff.Count then
      local fontSize = db.unitframes.debuffs.size / 2.75
      debuff.Count:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
      debuff.Count:ClearAllPoints()
      debuff.Count:SetPoint("BOTTOMRIGHT", debuff, "BOTTOMRIGHT", 2, 0)
    end
  end)
end