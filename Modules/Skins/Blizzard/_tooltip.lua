-- 12.0 secret values; keep this callable on builds that do not expose it
local canaccessvalue = canaccessvalue or function() return true end

local Module = SUI:NewModule("Skins.Tooltip");

function Module:OnEnable()
    if (SUI:Color()) then
        local theme = SUI.db.profile.general.theme

        local backdrop = {
            bgFile = "Interface\\Buttons\\WHITE8x8",
            bgColor = { 0.015, 0.015, 0.015, 0.97 },
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            borderColor = { 0.1, 0.1, 0.1, 0.9 },
            azeriteBorderColor = { 1, 0.3, 0, 0.9 },
            tile = false,
            tileEdge = false,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        }

        local function SafeTableGet(tbl, key)
            if not tbl or not key or (canaccessvalue and not canaccessvalue(key)) then
                return nil
            end

            local ok, value = pcall(function()
                return tbl[key]
            end)

            if not ok or (canaccessvalue and not canaccessvalue(value)) then
                return nil
            end

            return value
        end

        local function GetTooltipDataValue(data, ...)
            local value = data
            for i = 1, select("#", ...) do
                value = SafeTableGet(value, select(i, ...))
                if value == nil then
                    return nil
                end
            end

            return value
        end

        local function GetTooltipData(self)
            if not self or not self.GetTooltipData then
                return nil
            end

            local ok, data = pcall(self.GetTooltipData, self)
            if not ok or (canaccessvalue and not canaccessvalue(data)) then
                return nil
            end

            return data
        end

        local pendingTooltipSkins = {}

        local function CanStyleTooltip(self)
            if not self then
                return false
            end

            if self.IsForbidden then
                local ok, forbidden = pcall(self.IsForbidden, self)
                if ok and forbidden then
                    return false
                end
            end

            if self.CanBeAccessedInContext then
                local ok, canAccess = pcall(self.CanBeAccessedInContext, self)
                if ok and not canAccess then
                    return false
                end
            end

            return true
        end

        -- The Blizzard NineSlice center texture is partly translucent, so tinting it alone
        -- never gets fully opaque. Back it with a solid texture like the aura tooltip does.
        local function EnsureSolidBackground(self)
            if self.SUISolidBackground then
                return self.SUISolidBackground
            end

            local ok, tex = pcall(self.CreateTexture, self, nil, "BACKGROUND", nil, -8)
            if not ok or not tex then
                return nil
            end

            tex:SetTexture(backdrop.bgFile)
            -- Keep the backdrop inside the insets so the rounded border art stays visible,
            -- exactly like the aura tooltip backdrop does.
            tex:SetPoint("TOPLEFT", self, "TOPLEFT", backdrop.insets.left, -backdrop.insets.top)
            tex:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -backdrop.insets.right, backdrop.insets.bottom)
            self.SUISolidBackground = tex

            return tex
        end

        local function ApplyTooltipBackdrop(self)
            if not CanStyleTooltip(self) then
                return
            end

            local solid = EnsureSolidBackground(self)
            if solid then
                solid:SetVertexColor(unpack(backdrop.bgColor))
            end

            if self.NineSlice then
                if (theme == 'Dark') then
                    pcall(self.NineSlice.SetBorderColor, self.NineSlice, unpack(backdrop.borderColor))
                    if self.NineSlice.Center then
                        pcall(self.NineSlice.Center.SetVertexColor, self.NineSlice.Center, unpack(backdrop.bgColor))
                    end
                else
                    pcall(self.NineSlice.SetBorderColor, self.NineSlice, unpack(SUI:Color(0.35, 1)))
                    if self.NineSlice.Center then
                        pcall(self.NineSlice.Center.SetVertexColor, self.NineSlice.Center, unpack(backdrop.bgColor))
                    end
                end
            end
        end

        local function ScheduleTooltipBackdrop(self)
            if pendingTooltipSkins[self] then
                return
            end

            pendingTooltipSkins[self] = true
            C_Timer.After(0, function()
                pendingTooltipSkins[self] = nil
                ApplyTooltipBackdrop(self)
            end)
        end

        local function styleTooltip(self, style)
            if not CanStyleTooltip(self) then
                return
            end

            if style then
                ScheduleTooltipBackdrop(self)
            else
                ApplyTooltipBackdrop(self)
            end

            if self.NineSlice then
                if (theme == 'Dark') then
                    self.NineSlice:SetBorderColor(unpack(backdrop.borderColor))
                else
                    self.NineSlice:SetBorderColor(unpack(SUI:Color(0.35, 1)))
                end
            end
        end

        local function StyleAuraTooltipBackdrop()
            if not AuraContainerInbound or not AuraContainerInbound.SetTooltipBackdrop or not CreateColor then
                return
            end

            local borderColor
            if theme == 'Dark' then
                borderColor = CreateColor(unpack(backdrop.borderColor))
            else
                borderColor = CreateColor(unpack(SUI:Color(0.35, 1)))
            end

            pcall(AuraContainerInbound.SetTooltipBackdrop, {
                backdropInfo = backdrop,
                centerColor = CreateColor(unpack(backdrop.bgColor)),
                borderColor = borderColor
            })
        end

        local function itemTooltip(self)
            styleTooltip(self)

            if (self.NineSlice) then
                local itemGUID
                local itemLink
                local tooltipData = GetTooltipData(self)
                if tooltipData then
                    itemGUID = GetTooltipDataValue(tooltipData, "guid")
                    if itemGUID then
                        local ok, link = pcall(C_Item.GetItemLinkByGUID, itemGUID)
                        itemLink = ok and link or nil
                    end

                    itemLink = GetTooltipDataValue(tooltipData, "hyperlink") or itemLink
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
            styleTooltip(self)

            local tooltipData = GetTooltipData(self)
            if tooltipData then
                local tooltipName = GetTooltipDataValue(tooltipData, "lines", 2, "leftText")
                local tooltipColor = GetTooltipDataValue(tooltipData, "lines", 2, "leftColor")
                if not tooltipName or not tooltipColor then
                    return
                end

                local _, itemLink = C_Item.GetItemInfo(tooltipName)
                if itemLink then
                    self.NineSlice:SetBorderColor(tooltipColor.r, tooltipColor.g, tooltipColor.b)
                end
            end
        end

        local function SafeAddTooltipPostCall(tooltipType, callback)
            if tooltipType then
                TooltipDataProcessor.AddTooltipPostCall(tooltipType, callback)
            end
        end

        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, itemTooltip)
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Macro, macroItemTooltip)
        SafeAddTooltipPostCall(Enum.TooltipDataType.Spell, styleTooltip)
        SafeAddTooltipPostCall(Enum.TooltipDataType.UnitAura, styleTooltip)
        SafeAddTooltipPostCall(Enum.TooltipDataType.Unit, styleTooltip)

        local function HookTooltipMethod(tooltip, method)
            if tooltip and type(tooltip[method]) == "function" then
                hooksecurefunc(tooltip, method, function(self)
                    ScheduleTooltipBackdrop(self)
                end)
            end
        end

        StyleAuraTooltipBackdrop()
        C_Timer.After(0, StyleAuraTooltipBackdrop)
        C_Timer.After(1, StyleAuraTooltipBackdrop)

        hooksecurefunc("SharedTooltip_SetBackdropStyle", styleTooltip)
        local tooltips = { GameTooltip, ShoppingTooltip1, ShoppingTooltip2, ItemRefTooltip, ItemRefShoppingTooltip1,
            ItemRefShoppingTooltip2, WorldMapTooltip,
            WorldMapCompareTooltip1, WorldMapCompareTooltip2 }
        for i, tooltip in next, tooltips do
            styleTooltip(tooltip)
            if tooltip and tooltip.HookScript then
                tooltip:HookScript("OnShow", function(self)
                    ScheduleTooltipBackdrop(self)
                end)
            end
        end

        HookTooltipMethod(GameTooltip, "SetUnitAura")
        HookTooltipMethod(GameTooltip, "SetUnitBuff")
        HookTooltipMethod(GameTooltip, "SetUnitDebuff")
    end
end
