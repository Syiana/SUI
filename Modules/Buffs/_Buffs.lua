local Buffs = SUI:NewModule("Buffs.Buffs");

function Buffs:OnEnable()
  if IsAddOnLoaded("BlizzBuffsFacade") then return end

  local function UpdateDuration(self, timeLeft)
    if timeLeft <= 60 then
        self.duration:SetFormattedText("%ds", timeLeft)
    elseif timeLeft >= 60 then
        self.duration:SetFormattedText("%dm", SecondsToMinutes(timeLeft))
    elseif timeLeft >= 3600 then
        self.duration:SetFormattedText("%dh", math.floor(timeLeft / SECONDS_PER_HOUR))
    elseif timeLeft >= 86400 then
        self.duration:SetFormattedText("%dd", math.floor(timeLeft / SECONDS_PER_DAY))
    end
  end

  function updateBuffs()
    local AuraNum = BuffFrame.AuraContainer:GetNumChildren()
    local Children = { BuffFrame.AuraContainer:GetChildren() }

    for _, child in pairs(Children) do
      local icon =  child.Icon
      local t = select(_, BuffFrame.AuraContainer:GetChildren())
      local duration = t.duration
      local count = t.count
      local point, relativeTo, relativePoint, xOfs, yOfs = icon:GetPoint()
      if (child.Border) then
        child.Border:Hide()
      end

      icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
      icon:SetSize(32, 32)
    
      if not icon.border then
        local border = CreateFrame("Frame", "SUIBuffBorder", t, "BackdropTemplate")
        border:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs + 5)
        border:SetSize(42, 42)
        border:SetFrameLevel(3)
      
        local backdrop = {
          edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
          edgeSize = 6,
          insets = { left = 6, right = 6, top = 6, bottom = 6 },
        }

        border:SetBackdrop(backdrop)
        border:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))
        icon.border = border

        local texture = icon.border:CreateTexture()
        texture:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Core\\Normal_N")
        texture:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs + 5)
        texture:SetSize(42, 42)
        --texture:SetVertexColor(0, 0, 0)
        texture:SetVertexColor(unpack(SUI:Color(0.25)))
        icon.border.texture = texture
        border:Show()

        -- Update Duration Format
        if t.UpdateDuration then
          hooksecurefunc(t, "UpdateDuration", UpdateDuration)
        end
      end

      if (count) then
        -- Set Stack Font size and reposition it
        count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        count:ClearAllPoints()
        count:SetPoint("TOPRIGHT", t, "TOPRIGHT", 0, -2)
      end

      -- Set Duration Font size and reposition it
      if duration:GetText() ~= nil then
        duration:SetText(gsub(duration:GetText(), " ", ""))
        --print(gsub(duration:GetText(), " ", ""))
        --print(duration:GetText())
      end
      
      duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
      duration:ClearAllPoints()
      duration:SetPoint("CENTER", t, "BOTTOM", 0, 13)
      duration:SetDrawLayer("OVERLAY")
    end
  end

  local frame = CreateFrame("Frame")
  frame:RegisterEvent("PLAYER_ENTERING_WORLD", self, "Update")
	frame:RegisterUnitEvent("UNIT_AURA", self, "Update")
  frame:RegisterEvent("WEAPON_ENCHANT_CHANGED")
  frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  frame:SetScript("OnEvent", function(self, event, ...)
    updateBuffs()
  end)
end
