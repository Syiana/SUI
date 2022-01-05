local Module = SUI:NewModule("Skins.Tooltip");

function Module:OnEnable()
  if (SUI:Color()) then
    hooksecurefunc("SharedTooltip_SetBackdropStyle", function(self, style)
      SUI:AddMixin(self)
      local backdrop = {
        bgFile = "Interface\\Buttons\\WHITE8x8",
        bgColor = {0.03, 0.03, 0.03, 0.9},
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        borderColor = {0.1, 0.1, 0.1, 0.9},
        azeriteBorderColor = {1, 0.3, 0, 0.9},
        tile = false,
        tileEdge = false,
        tileSize = 16,
        edgeSize = 16,
        insets = {left=3, right=3, top=3, bottom=3}
      }
      self:SetBackdrop(backdrop)
      self:SetBackdropColor(unpack(SUI:Color(0.3, 0.9)))
      self:SetBackdropBorderColor(0.03, 0.03, 0.03, 0)
      if (self.NineSlice) then
        local _, itemLink = self:GetItem()
        if itemLink then
          local azerite = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemLink) or C_AzeriteItem.IsAzeriteItemByID(itemLink) or false
          local _, _, itemRarity = GetItemInfo(itemLink)
          local r, g, b = 0.1, 0.1, 0.1
          if itemRarity then r, g, b = GetItemQualityColor(itemRarity) end
          if azerite and backdrop.azeriteBorderColor then
            self.NineSlice:SetBorderColor(unpack(backdrop.azeriteBorderColor))
          else
            self.NineSlice:SetBorderColor(r, g, b, 0.9)
          end
        else
          self.NineSlice:SetBorderColor(unpack(backdrop.borderColor))
        end
      end
    end)
  end
end