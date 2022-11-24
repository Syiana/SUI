local Module = SUI:NewModule("UnitFrames.Player");

function Module:OnEnable()
  local db = {
    unitframes = SUI.db.profile.unitframes,
    texture = SUI.db.profile.general.texture,
    nameplates = SUI.db.profile.nameplates.style
  }

  if not db.unitframes.totemicons then
    hooksecurefunc(TotemFrame, "Update", function()
      TotemFrame:Hide()
    end)
  end

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

  if db.texture ~= [[Interface\Default]] then
    local function updateTextures(self, event)
      if event == "PLAYER_ENTERING_WORLD" then
        self.healthbar:SetStatusBarTexture(db.texture)
        self.healthbar.AnimatedLossBar:SetStatusBarTexture(db.texture)
        self.myHealPredictionBar:SetTexture(db.texture)
        self.otherHealPredictionBar:SetTexture(db.texture)
        self.myManaCostPredictionBar:SetTexture(db.texture)
      end

      local powerColor = GetPowerColor(self.manabar.powerType)
      self.manabar.texture:SetTexture(db.texture)
      self.manabar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)

      if db.nameplates ~= 'Default' then
        ClassNameplateManaBarFrame:SetStatusBarTexture(db.texture)
      end
    end

    PlayerFrame:HookScript("OnEvent", function(self, event)
      updateTextures(self, event)
    end)

    PetFrame:HookScript("OnEvent", function(self, event)
      if event == "PLAYER_ENTERING_WORLD" then
        self.healthbar:SetStatusBarTexture(db.texture)
      end

      local powerColor = GetPowerColor(self.manabar.powerType)
      self.manabar.texture:SetTexture(db.texture)
      self.manabar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
    end)
  end

  local statusTexture = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture;
  local statusAnimation = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop

  hooksecurefunc("PlayerFrame_UpdateStatus", function(self)
    if (IsResting()) then
      statusTexture:Hide()
      statusAnimation:Hide()
    end
  end)
end