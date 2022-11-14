local Module = SUI:NewModule("Skins.Tooltip");

function Module:OnEnable()
  if (SUI:Color()) then
    local theme = SUI.db.profile.general.theme
    local function styleTooltip(self, style)
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
      self:SetBackdropBorderColor(0.1, 0.1, 0.1, 0)
      if (theme == 'Dark') then
        self:SetBackdropColor(unpack(backdrop.bgColor))
        self.NineSlice:SetBorderColor(unpack(backdrop.borderColor))
      else
        self:SetBackdropColor(unpack(SUI:Color(0.3, 0.3)))
        self.NineSlice:SetBorderColor(unpack(SUI:Color(0.35, 1)))
      end
    end
    local function itemTooltip(self)
      if (self.NineSlice) then
        local itemGUID
        local itemLink
        if self:GetTooltipData() then
          if self:GetTooltipData().guid then
            itemGUID = self:GetTooltipData().guid
            itemLink = C_Item.GetItemLinkByGUID(itemGUID)
          end

          if self:GetTooltipData().hyperlink then
            itemLink = self:GetTooltipData().hyperlink
          end
        end

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
        end
      end
    end

    local function macroItemTooltip(self)
      local tooltipData = self:GetTooltipData()
      local tooltipName = tooltipData.lines[2].leftText
      local tooltipColor = tooltipData.lines[2].leftColor
      --print(tooltipColor.r, tooltipColor.g, tooltipColor.b)
      local _, itemLink = GetItemInfo(tooltipName)
      if itemLink then
        self.NineSlice:SetBorderColor(tooltipColor.r, tooltipColor.g, tooltipColor.b)
      end
    end

    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, styleTooltip)
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Object, styleTooltip)
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, styleTooltip)
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Macro, styleTooltip)
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Macro, macroItemTooltip)
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, itemTooltip)

    local tooltips = { GameTooltip,ShoppingTooltip1,ShoppingTooltip2,ItemRefTooltip,ItemRefShoppingTooltip1,ItemRefShoppingTooltip2,WorldMapTooltip,
    WorldMapCompareTooltip1,WorldMapCompareTooltip2 }
    for i, tooltip in next, tooltips do
      styleTooltip(tooltip)
    end
  end

  SUI.Theme.Register("Tooltip", function(...)
    local init, theme, color = ...
    local function styleTooltip(self, style)
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
      self:SetBackdropBorderColor(0.1, 0.1, 0.1, 0)
      if (theme == 'Dark') then
        self:SetBackdropColor(unpack(backdrop.bgColor))
      else
        self:SetBackdropColor(unpack(SUI:Color(0.3, 0.3)))
      end
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
          if (theme == 'Dark') then
            self.NineSlice:SetBorderColor(unpack(backdrop.borderColor))
          else
            self.NineSlice:SetBorderColor(unpack(SUI:Color(0.35, 1)))
          end
        end
      end
    end

    hooksecurefunc("SharedTooltip_SetBackdropStyle", styleTooltip)
    local tooltips = { GameTooltip,ShoppingTooltip1,ShoppingTooltip2,ItemRefTooltip,ItemRefShoppingTooltip1,ItemRefShoppingTooltip2,WorldMapTooltip,
    WorldMapCompareTooltip1,WorldMapCompareTooltip2 }
    for i, tooltip in next, tooltips do
      styleTooltip(tooltip)
    end
  end)
end