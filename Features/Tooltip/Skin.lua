--[[
    SUI 2.0 - Features/Tooltip/Skin.lua

    Dark backdrop and theme-tinted border for Blizzard tooltips, with the
    border of item and macro tooltips in the item's quality colour. Blizzard
    resets the backdrop whenever a tooltip is re-styled or shown, so the
    colours are re-applied from those hooks and, like 1.x, once more one frame
    after aura, spell and unit tooltips are filled. Nothing happens with the
    Blizzard theme.
]]

local _, ns = ...
local SUI = ns.SUI

local next, _G = next, _G
local CanAccess = SUI.Compat.CanAccess
local GetItemInfo = SUI.Compat.GetItemInfo

local F = SUI:NewFeature("Tooltip.Skin", { category = "tooltip" })

local TOOLTIPS = {
    "GameTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ItemRefTooltip",
    "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2", "EmbeddedItemTooltip",
    "WorldMapTooltip", "WorldMapCompareTooltip1", "WorldMapCompareTooltip2",
}

local AURA_METHODS = { "SetUnitAura", "SetUnitBuff", "SetUnitDebuff" }

local BG_R, BG_G, BG_B, BG_A = 0.015, 0.015, 0.015, 0.97
local QUALITY_A = 0.9
local borderR, borderG, borderB, borderA = 0.1, 0.1, 0.1, 0.9
local plainR, plainG, plainB = 0.15, 0.15, 0.15 -- border of common/poor items

local backgrounds = setmetatable({}, { __mode = "k" }) -- tooltip -> solid texture
local itemBorder = setmetatable({}, { __mode = "k" })  -- tooltip -> colour table, or true for common items
local clearable = setmetatable({}, { __mode = "k" })   -- tooltips whose OnTooltipCleared is hooked
local pending = setmetatable({}, { __mode = "k" })     -- tooltips to re-style next frame
local flushQueued = false
local apply

-- 1.x: Dark uses a fixed grey border at 0.9 alpha, other themes the theme colour at full alpha.
local function updateBorderColor()
    if SUI.Theme.name == "Dark" then
        borderR, borderG, borderB, borderA = 0.1, 0.1, 0.1, 0.9
    else
        borderR, borderG, borderB = SUI.Theme:Color(0.35)
        borderA = 1
    end
    plainR, plainG, plainB = SUI.Theme:Color(0.15)
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
function apply(tooltip, _, embedded)
    if not SUI.Theme.enabled or tooltip:IsForbidden() then
        return
    end
    local bg = backgrounds[tooltip]
    if embedded or tooltip.IsEmbedded then
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
    local color = itemBorder[tooltip]
    if color == true then
        setBorder(tooltip, plainR, plainG, plainB, 1)
    elseif color then
        setBorder(tooltip, color.r, color.g, color.b, QUALITY_A)
    else
        setBorder(tooltip, borderR, borderG, borderB, borderA)
    end
end

local function flush()
    flushQueued = false
    for tooltip in next, pending do
        pending[tooltip] = nil
        if F.enabled then
            apply(tooltip)
        end
    end
end

-- Blizzard re-styles some tooltips after the fill; style them again next frame.
local function applyLater(tooltip)
    if not F.enabled or tooltip:IsForbidden() then
        return
    end
    apply(tooltip)
    pending[tooltip] = true
    if not flushQueued then
        flushQueued = true
        C_Timer.After(0, flush)
    end
end

local function onCleared(tooltip)
    itemBorder[tooltip] = nil
end

local function setItemBorder(tooltip, color)
    if clearable[tooltip] then
        itemBorder[tooltip] = color
    end
    if color == true then
        setBorder(tooltip, plainR, plainG, plainB, 1)
    else
        setBorder(tooltip, color.r, color.g, color.b, QUALITY_A)
    end
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
    local color = q and q >= 2 and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[q]
    setItemBorder(tooltip, color or true)
end

-- Retail macro tooltips for items: 1.x took the border from the item name colour.
local function onMacro(tooltip, data)
    if not F.enabled or not SUI.Theme.enabled or tooltip:IsForbidden() then
        return
    end
    applyLater(tooltip)
    local lines = data and data.lines
    local line = lines and lines[2]
    local name, color = line and line.leftText, line and line.leftColor
    if not name or not color or not CanAccess(name) or not CanAccess(color.r) then
        return
    end
    local _, link = GetItemInfo(name)
    if link then
        setItemBorder(tooltip, color)
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
        borderColor = CreateColor(borderR, borderG, borderB, borderA),
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
    for _, method in next, AURA_METHODS do
        if GameTooltip[method] then
            self:Hook(GameTooltip, method, applyLater)
        end
    end
    SUI.Compat.OnTooltipItem(onItem)
    SUI.Compat.OnTooltipSpell(applyLater)
    SUI.Compat.OnTooltipUnit(applyLater)
    local processor, types = _G.TooltipDataProcessor, Enum and Enum.TooltipDataType
    if processor and types then
        if types.UnitAura then
            processor.AddTooltipPostCall(types.UnitAura, applyLater)
        end
        if types.Macro then
            processor.AddTooltipPostCall(types.Macro, onMacro)
        end
    end
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
