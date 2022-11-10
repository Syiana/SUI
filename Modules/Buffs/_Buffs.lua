local Buffs = SUI:NewModule("Buffs.Buffs");

function Buffs:OnEnable()
  if IsAddOnLoaded("BlizzBuffsFacade") then return end

  local db = SUI.db.profile.unitframes.buffs

  local function UpdateDuration(self, timeLeft)
    if timeLeft >= 86400 then
      self.duration:SetFormattedText("%dd", ceil(timeLeft / 86400))
    elseif timeLeft >= 3600 then
      self.duration:SetFormattedText("%dh", ceil(timeLeft / 3600))
    elseif timeLeft >= 60 then
      self.duration:SetFormattedText("%dm", ceil(timeLeft / 60))
    else
      self.duration:SetFormattedText("%ds", timeLeft)
    end
  end

  local function ButtonDefault(button)

  end

  local function ButtonBackdrop(button)
    local Backdrop = {
      bgFile = "",
      edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
      tile = false,
      tileSize = 32,
      edgeSize = 5,
      insets = { left = 5, right = 5, top = 5, bottom = 5 }
  }

    local icon = button.Icon
    local point, relativeTo, relativePoint, xOfs, yOfs = icon:GetPoint()

    local border = CreateFrame("Frame", nil, button)
    border:SetSize(icon:GetWidth(), icon:GetHeight())
    border:SetPoint("CENTER", button, "CENTER", 0, 5)

    local shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
    --shadow:SetSize(icon:GetWidth(), icon:GetHeight())
    shadow:SetPoint("TOPLEFT", border, "TOPLEFT", -4, 4)
    shadow:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 4, -4)
    --shadow:SetFrameLevel(button:GetFrameLevel() - 1)
    shadow:SetBackdrop(Backdrop)
    shadow:SetBackdropBorderColor(0, 0, 0)


    button.SUIBorder = border


  end

  local function ButtonBordered(button)

  end

  function updateBuffs()
    local Children = { BuffFrame.AuraContainer:GetChildren() }

    for index, child in pairs(Children) do
      local frame =     select(index, BuffFrame.AuraContainer:GetChildren())
      local icon =      frame.Icon
      local duration =  frame.duration
      local count =     frame.count

      icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

      if frame.Border then frame.Border:Hide() end

      -- Update Duration Format
      --if frame.UpdateDuration and frame.timeLeft ~= nil then
        --hooksecurefunc(frame, "UpdateDuration", UpdateDuration)
      --end

      -- Set Stack Font size and reposition it
      if count then
        count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        count:ClearAllPoints()
        count:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
      end

      duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
      duration:ClearAllPoints()
      duration:SetPoint("CENTER", frame, "BOTTOM", 0, 15)
      duration:SetDrawLayer("OVERLAY")
      
      if frame.SUIBorder == nil then
        ButtonBackdrop(frame)
      end
    end

    if not db.collapse then
      BuffFrame.CollapseAndExpandButton:Hide()
    end
  end

  local frame = CreateFrame("Frame")
  frame:RegisterEvent("PLAYER_ENTERING_WORLD")
  frame:RegisterUnitEvent("UNIT_AURA", "player")
  frame:RegisterEvent("WEAPON_ENCHANT_CHANGED")
  frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  frame:SetScript("OnEvent", updateBuffs)

  hooksecurefunc(BuffButtonMixin, "UpdateDuration", UpdateDuration)
end
