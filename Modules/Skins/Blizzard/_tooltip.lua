local Module = SUI:NewModule("Skins.Tooltip");

function Module:OnEnable()
    if (SUI:Color()) then
        local theme = SUI.db.profile.general.theme

        local backdrop = {
            bgFile = "Interface\\Buttons\\WHITE8x8",
            bgColor = { 0.03, 0.03, 0.03, 0.9 },
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            borderColor = { 0.1, 0.1, 0.1, 0.9 },
            azeriteBorderColor = { 1, 0.3, 0, 0.9 },
            tile = false,
            tileEdge = false,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        }

        local function styleTooltip(self, style)
            if self then
                SUI:AddMixin(self)
                self:SetBackdrop(backdrop)
                self:SetBackdropBorderColor(0.1, 0.1, 0.1, 0)
                if (theme == 'Dark') then
                    self:SetBackdropColor(unpack(backdrop.bgColor))
                else
                    self:SetBackdropColor(unpack(SUI:Color(0.3, 0.3)))
                end
                if self.NineSlice then
                    if (theme == 'Dark') then
                        self.NineSlice:SetBorderColor(unpack(backdrop.borderColor))
                    else
                        self.NineSlice:SetBorderColor(unpack(SUI:Color(0.35, 1)))
                    end
                end
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
                    local azerite = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemLink) or
                        C_AzeriteItem.IsAzeriteItemByID(itemLink) or false
                    local _, _, itemRarity = C_Item.GetItemInfo(itemLink)
                    
                    if itemRarity and itemRarity >= 2 then
                        local r, g, b = C_Item.GetItemQualityColor(itemRarity)
                        self.NineSlice:SetBorderColor(r, g, b, 0.9)
                    else
                        self.NineSlice:SetBorderColor(unpack(SUI:Color(0.15)))
                    end
                end
            end
        end

        local function macroItemTooltip(self)
            if self:GetTooltipData() and self:GetTooltipData().lines and self:GetTooltipData().lines[2] and
                self:GetTooltipData().lines[2].leftText and self:GetTooltipData().lines[2].leftColor then
                local tooltipData = self:GetTooltipData()
                local tooltipName = tooltipData.lines[2].leftText
                local tooltipColor = tooltipData.lines[2].leftColor
                local _, itemLink = C_Item.GetItemInfo(tooltipName)
                if itemLink then
                    self.NineSlice:SetBorderColor(tooltipColor.r, tooltipColor.g, tooltipColor.b)
                end
            end
        end

        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, itemTooltip)
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Macro, macroItemTooltip)

        hooksecurefunc("SharedTooltip_SetBackdropStyle", styleTooltip)
        local tooltips = { GameTooltip, ShoppingTooltip1, ShoppingTooltip2, ItemRefTooltip, ItemRefShoppingTooltip1,
            ItemRefShoppingTooltip2, WorldMapTooltip,
            WorldMapCompareTooltip1, WorldMapCompareTooltip2 }
        for i, tooltip in next, tooltips do
            styleTooltip(tooltip)
        end
    end
end
