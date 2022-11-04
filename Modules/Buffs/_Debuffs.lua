local Debuffs = SUI:NewModule("Buffs.Debuffs");

function Debuffs:OnEnable()
  if IsAddOnLoaded("BlizzBuffsFacade") then return end

  -- DebuffType Colors for the Debuff Border
  DebuffTypeColor = {}
  DebuffTypeColor["none"]    = { r = 0.80, g = 0, b = 0 };
  DebuffTypeColor["Magic"]    = { r = 0.20, g = 0.60, b = 1.00 };
  DebuffTypeColor["Curse"]    = { r = 0.60, g = 0.00, b = 1.00 };
  DebuffTypeColor["Disease"]    = { r = 0.60, g = 0.40, b = 0 };
  DebuffTypeColor["Poison"]    = { r = 0.00, g = 0.60, b = 0 };

  function updateDebuffs()
    local AuraNum = DebuffFrame.AuraContainer:GetNumChildren()
    local Children = { DebuffFrame.AuraContainer:GetChildren() }

    for _, child in pairs(Children) do
      local icon =  child.Icon
      local t = select(_, DebuffFrame.AuraContainer:GetChildren())
      local dur = t.duration
      local count = t.count
      local point, relativeTo, relativePoint, xOfs, yOfs = icon:GetPoint()
      child.Border:Hide()

      icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
      icon:SetSize(32, 32)

      HOUR_ONELETTER_ABBR = "%dh"
      DAY_ONELETTER_ABBR = "%dd"
      MINUTE_ONELETTER_ABBR = "%dm"
      SECOND_ONELETTER_ABBR = "%ds"
    
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
        texture:SetVertexColor(0, 0, 0)
        icon.border.texture = texture
        border:Show()
      end

      if (count) then
        -- Set Stack Font size and reposition it
        count:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
        count:ClearAllPoints()
        count:SetPoint("TOPRIGHT", t, "TOPRIGHT", 0, -2)
      end

      -- Set Duration FOnt size and reposition it
      dur:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
      dur:ClearAllPoints()
      dur:SetPoint("CENTER", t, "BOTTOM", 0, 13)
      dur:SetDrawLayer("OVERLAY")

      -- Set the color of the Debuff Border
      local debuffType
      if (child.buttonInfo) then
        debuffType = child.buttonInfo.debuffType
      end
      if (icon.border) then
        local color
        if (debuffType) then
          color = DebuffTypeColor[debuffType]
        else
          color = DebuffTypeColor["none"]
        end
        icon.border.texture:SetVertexColor(color.r, color.g, color.b, 0.8)
      end
    end
  end

  local frame = CreateFrame("Frame")
  frame:RegisterEvent("PLAYER_ENTERING_WORLD", self, "Update")
  frame:RegisterUnitEvent("UNIT_AURA", self, "Update")
  frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  frame:SetScript("OnEvent", function(self, event, ...)
    updateDebuffs()
  end)
end