--[[
    SUI 2.0 - Features/Tooltip/Skin.lua

    Dark backdrop and theme-tinted border for Blizzard tooltips, with the
    border of item tooltips in the item's quality colour. Blizzard resets the
    backdrop whenever a tooltip is re-styled or shown, so the colours are
    re-applied from those two hooks. Nothing happens with the Blizzard theme.
]]

local _, ns = ...
local SUI = ns.SUI

local next, _G = next, _G
local CanAccess = SUI.Compat.CanAccess
local GetItemInfo = SUI.Compat.GetItemInfo
local GetItemQualityColor = SUI.Compat.GetItemQualityColor

local F = SUI:NewFeature("Tooltip.Skin", { category = "tooltip" })

local TOOLTIPS = {
    "GameTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ItemRefTooltip",
    "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2", "EmbeddedItemTooltip",
    "WorldMapTooltip", "WorldMapCompareTooltip1", "WorldMapCompareTooltip2",
}

local BG_R, BG_G, BG_B, BG_A = 0.015, 0.015, 0.015, 0.97
local borderR, borderG, borderB = 0.1, 0.1, 0.1
local BORDER_A = 0.9

local backgrounds = setmetatable({}, { __mode = "k" }) -- tooltip -> solid texture
local quality = setmetatable({}, { __mode = "k" })     -- tooltip -> item quality (only hooked tooltips)
local clearable = setmetatable({}, { __mode = "k" })   -- tooltips whose OnTooltipCleared is hooked

local function updateBorderColor()
    if SUI.Theme.name == "Dark" then
        borderR, borderG, borderB = 0.1, 0.1, 0.1
    else
        borderR, borderG, borderB = SUI.Theme:Color(0.35)
    end
end

local function setBorder(tooltip, r, g, b, a)
    local nineSlice = tooltip.NineSlice
    if nineSlice then
        nineSlice:SetBorderColor(r, g, b, a)
    elseif tooltip.SetBackdropBorderColor then
        tooltip:SetBackdropBorderColor(r, g, b, a)
    end
end

-- Hook target for SharedTooltip_SetBackdropStyle(tooltip, style, embedded) and OnShow.
local function apply(tooltip, _, embedded)
    if not SUI.Theme.enabled or tooltip:IsForbidden() then
        return
    end
    local bg = backgrounds[tooltip]
    if embedded then
        if bg then
            bg:Hide()
        end
        return
    end
    if not bg then
        -- The NineSlice centre is translucent; a solid texture inside the insets makes it opaque.
        bg = tooltip:CreateTexture(nil, "BACKGROUND", nil, -8)
        bg:SetColorTexture(BG_R, BG_G, BG_B, BG_A)
        bg:SetPoint("TOPLEFT", 3, -3)
        bg:SetPoint("BOTTOMRIGHT", -3, 3)
        backgrounds[tooltip] = bg
    end
    bg:Show()
    local nineSlice = tooltip.NineSlice
    if nineSlice then
        nineSlice:SetCenterColor(BG_R, BG_G, BG_B, BG_A)
    elseif tooltip.SetBackdropColor then
        tooltip:SetBackdropColor(BG_R, BG_G, BG_B, BG_A)
    end
    local q = quality[tooltip]
    if q then
        local r, g, b = GetItemQualityColor(q)
        setBorder(tooltip, r, g, b, BORDER_A)
    else
        setBorder(tooltip, borderR, borderG, borderB, BORDER_A)
    end
end

local function onCleared(tooltip)
    quality[tooltip] = nil
end

local function onItem(tooltip, data)
    if not F.enabled or not SUI.Theme.enabled or tooltip:IsForbidden() then
        return
    end
    local link = data and data.hyperlink
    if not link and tooltip.GetItem then
        local _
        _, link = tooltip:GetItem()
    end
    if not link or not CanAccess(link) then
        return
    end
    local _, _, q = GetItemInfo(link)
    if q and q >= 2 then
        if clearable[tooltip] then
            quality[tooltip] = q
        end
        local r, g, b = GetItemQualityColor(q)
        setBorder(tooltip, r, g, b, BORDER_A)
    end
end

-- Midnight aura tooltips are drawn by a container with its own backdrop setter.
local function styleAuraContainer()
    local container = _G.AuraContainerInbound
    if not (container and container.SetTooltipBackdrop and CreateColor) or not SUI.Theme.enabled then
        return
    end
    container.SetTooltipBackdrop({
        backdropInfo = {
            bgFile = SUI.Media.blank,
            edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
            edgeSize = 16,
            insets = { left = 3, right = 3, top = 3, bottom = 3 },
        },
        centerColor = CreateColor(BG_R, BG_G, BG_B, BG_A),
        borderColor = CreateColor(borderR, borderG, borderB, BORDER_A),
    })
end

local function restore()
    local border, center = _G.TOOLTIP_DEFAULT_COLOR, _G.TOOLTIP_DEFAULT_BACKGROUND_COLOR
    for tooltip, bg in next, backgrounds do
        bg:Hide()
        if border and center then
            local nineSlice = tooltip.NineSlice
            if nineSlice then
                nineSlice:SetBorderColor(border.r, border.g, border.b, 1)
                nineSlice:SetCenterColor(center.r, center.g, center.b, 1)
            end
        end
    end
end

function F:OnLoad()
    if SharedTooltip_SetBackdropStyle then
        self:Hook("SharedTooltip_SetBackdropStyle", apply)
    end
    for i = 1, #TOOLTIPS do
        local tooltip = _G[TOOLTIPS[i]]
        if tooltip and tooltip.HookScript then
            self:HookScript(tooltip, "OnShow", apply)
            tooltip:HookScript("OnTooltipCleared", onCleared)
            clearable[tooltip] = true
        end
    end
    SUI.Compat.OnTooltipItem(onItem)
end

function F:OnEnable()
    updateBorderColor()
    styleAuraContainer()
    -- The aura container is created a little after login.
    self:After(1, styleAuraContainer)
end

function F:OnThemeChanged()
    updateBorderColor()
    if SUI.Theme.enabled then
        styleAuraContainer()
    else
        restore()
    end
end
