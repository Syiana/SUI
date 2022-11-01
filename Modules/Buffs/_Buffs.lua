local Buffs = SUI:NewModule("Buffs.Buffs");

function Buffs:OnEnable()
  if IsAddOnLoaded("BlizzBuffsFacade") then return end
  local frame = CreateFrame("Frame")

  frame:RegisterEvent("PLAYER_ENTERING_WORLD", self, "Update")
	frame:RegisterUnitEvent("UNIT_AURA", self, "Update")
  frame:RegisterEvent("WEAPON_ENCHANT_CHANGED");
  frame:SetScript("OnEvent", function(self, event, ...)
    updateBuffs()
    BuffFrame.CollapseAndExpandButton:Hide()
  end)


  function updateBuffs()
    local AuraNum = BuffFrame.AuraContainer:GetNumChildren()
    local Children = { BuffFrame.AuraContainer:GetChildren() }

    for _, child in pairs(Children) do
    local icon =  child.Icon
    local t = select(_, BuffFrame.AuraContainer:GetChildren())
    local dur = t.duration
    local point, relativeTo, relativePoint, xOfs, yOfs = icon:GetPoint()

    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    icon:SetSize(32, 32)

    HOUR_ONELETTER_ABBR = "%dh"
    DAY_ONELETTER_ABBR = "%dd"
    MINUTE_ONELETTER_ABBR = "%dm"
    SECOND_ONELETTER_ABBR = "%ds"

    local slot = child:GetID()
    if(slot) then
      local itemID = GetInventoryItemID("player", slot);
      local itemIcon = GetItemIcon(itemID)

      if not t.newIcon then
        local newIcon = CreateFrame("Frame", "NewIcon", t, "BackdropTemplate")
        newIcon:SetSize(32, 32)
        newIcon:SetAllPoints()
        newIcon:SetFrameLevel(3)
        t.newIcon = newIcon

        local newIconTexture = t.newIcon:CreateTexture()
        newIconTexture:SetTexture(itemIcon)
        newIconTexture:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
        newIconTexture:SetSize(32,32)
        newIconTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        newIcon:Show()
      end
    end
    
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

      dur:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
      dur:ClearAllPoints()
      dur:SetPoint("CENTER", t, "BOTTOM", 0, 13)
      dur:SetDrawLayer("OVERLAY")

    end
end
end
