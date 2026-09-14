--[[
    SUI 2.0 - Core/Compat.lua

    The only place that knows about API differences between Retail, Mists,
    TBC and Vanilla. Features call SUI.Compat.* and never branch on the client
    themselves. Each function is resolved once at load time, so there is no
    per-call version check.

    Rule: add a wrapper here only when at least two features need it. A
    difference that matters to one feature stays local to that feature.
]]

local _, ns = ...
local SUI = ns.SUI

local Compat = {}
SUI.Compat = Compat

-- Midnight (12.x) secret values -------------------------------------------
-- In restricted contexts some unit data is returned as a "secret" that must
-- not be compared, used in arithmetic or used as a table key. On clients
-- without secret values every value is accessible.
Compat.CanAccess = canaccessvalue or function()
    return true
end
Compat.IsSecret = issecretvalue or function()
    return false
end

-- Add-ons -----------------------------------------------------------------
local C_AddOns = C_AddOns
Compat.IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded
Compat.LoadAddOn = C_AddOns and C_AddOns.LoadAddOn or LoadAddOn
Compat.GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
Compat.EnableAddOn = C_AddOns and C_AddOns.EnableAddOn or EnableAddOn
Compat.DisableAddOn = C_AddOns and C_AddOns.DisableAddOn or DisableAddOn
Compat.GetAddOnEnableState = C_AddOns and C_AddOns.GetAddOnEnableState or function(name, character)
    return GetAddOnEnableState(character, name)
end

-- Spells --------------------------------------------------------------------
-- Returns name, icon for a spell id or name.
if C_Spell and C_Spell.GetSpellInfo then
    local GetSpellInfo = C_Spell.GetSpellInfo
    function Compat.GetSpellInfo(spell)
        local info = GetSpellInfo(spell)
        if info then
            return info.name, info.iconID, info.spellID
        end
    end
else
    local GetSpellInfo = GetSpellInfo
    function Compat.GetSpellInfo(spell)
        local name, _, icon, _, _, _, id = GetSpellInfo(spell)
        return name, icon, id
    end
end

Compat.GetSpellTexture = C_Spell and C_Spell.GetSpellTexture or GetSpellTexture

-- Items -------------------------------------------------------------------
Compat.GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
Compat.GetItemQualityColor = C_Item and C_Item.GetItemQualityColor or GetItemQualityColor
Compat.GetDetailedItemLevelInfo = C_Item and C_Item.GetDetailedItemLevelInfo or GetDetailedItemLevelInfo
Compat.GetItemInfoInstant = C_Item and C_Item.GetItemInfoInstant or GetItemInfoInstant

-- Containers: C_Container exists on every supported client, but keep the
-- aliases here so features do not have to know.
Compat.GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
Compat.GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
Compat.UseContainerItem = C_Container and C_Container.UseContainerItem or UseContainerItem

-- Returns quality, itemLink, noValue, stackCount for a bag slot.
if C_Container and C_Container.GetContainerItemInfo then
    local GetInfo = C_Container.GetContainerItemInfo
    function Compat.GetContainerItem(bag, slot)
        local info = GetInfo(bag, slot)
        if info then
            return info.quality, info.hyperlink, info.hasNoValue, info.stackCount
        end
    end
else
    function Compat.GetContainerItem(bag, slot)
        local _, count, _, quality, _, _, link, _, noValue = GetContainerItemInfo(bag, slot)
        return quality, link, noValue, count
    end
end

Compat.NUM_BAG_SLOTS = NUM_BAG_SLOTS or 4

-- Class colours -----------------------------------------------------------
-- Returns r, g, b (never a table, so no garbage in hot paths).
local classColorCache = {}
function Compat.GetClassColor(class)
    local c = classColorCache[class]
    if not c then
        c = (C_ClassColor and C_ClassColor.GetClassColor and class and C_ClassColor.GetClassColor(class))
            or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class])
            or (RAID_CLASS_COLORS and RAID_CLASS_COLORS[class])
        if not c then
            return 1, 1, 1
        end
        classColorCache[class] = c
    end
    return c.r, c.g, c.b
end

-- Auras -------------------------------------------------------------------
-- Calls fn(auraData) for each aura. auraData follows the retail table layout
-- (name, icon, applications, dispelName, duration, expirationTime,
-- sourceUnit, isStealable, spellId). Stop early by returning true from fn.
if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
    local GetAuraDataByIndex = C_UnitAuras.GetAuraDataByIndex
    function Compat.ForEachAura(unit, filter, fn)
        for i = 1, 255 do
            local aura = GetAuraDataByIndex(unit, i, filter)
            if not aura or fn(aura, i) then
                return
            end
        end
    end
else
    local UnitAura = UnitAura
    local aura = {}
    function Compat.ForEachAura(unit, filter, fn)
        for i = 1, 40 do
            local name, icon, count, dispelType, duration, expires, source, isStealable, _, spellId = UnitAura(unit, i, filter)
            if not name then
                return
            end
            aura.name, aura.icon, aura.applications, aura.dispelName = name, icon, count, dispelType
            aura.duration, aura.expirationTime, aura.sourceUnit = duration, expires, source
            aura.isStealable, aura.spellId = isStealable, spellId
            if fn(aura, i) then
                return
            end
        end
    end
end

-- Action bars ---------------------------------------------------------------
Compat.IsActionInRange = C_ActionBar and C_ActionBar.IsActionInRange or IsActionInRange
Compat.IsUsableAction = C_ActionBar and C_ActionBar.IsUsableAction or IsUsableAction
Compat.HasAction = C_ActionBar and C_ActionBar.HasAction or HasAction
-- Retail can push range updates per slot instead of being polled.
Compat.HasRangeEvents = C_ActionBar ~= nil and C_ActionBar.EnableActionRangeCheck ~= nil

-- Mouse -------------------------------------------------------------------
if GetMouseFoci then
    function Compat.GetMouseFocus()
        local foci = GetMouseFoci()
        return foci and foci[1]
    end
else
    Compat.GetMouseFocus = GetMouseFocus
end

-- Specialisation (Mists and Retail only) ----------------------------------
Compat.GetSpecialization = (C_SpecializationInfo and C_SpecializationInfo.GetSpecialization) or GetSpecialization or function()
    return nil
end

-- Tooltips ------------------------------------------------------------------
-- Calls fn(tooltip, data) whenever a unit tooltip is filled. On retail the
-- TooltipDataProcessor provides data; on classic `data` is nil.
function Compat.OnTooltipUnit(fn)
    if TooltipDataProcessor and Enum and Enum.TooltipDataType then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, fn)
    else
        GameTooltip:HookScript("OnTooltipSetUnit", fn)
    end
end

function Compat.OnTooltipItem(fn)
    if TooltipDataProcessor and Enum and Enum.TooltipDataType then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, fn)
    else
        GameTooltip:HookScript("OnTooltipSetItem", fn)
        if ItemRefTooltip then
            ItemRefTooltip:HookScript("OnTooltipSetItem", fn)
        end
    end
end

function Compat.OnTooltipSpell(fn)
    if TooltipDataProcessor and Enum and Enum.TooltipDataType then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, fn)
    else
        GameTooltip:HookScript("OnTooltipSetSpell", fn)
    end
end

-- Misc --------------------------------------------------------------------
Compat.SetCVar = C_CVar and C_CVar.SetCVar or SetCVar
Compat.GetCVar = C_CVar and C_CVar.GetCVar or GetCVar
Compat.GetCVarBool = C_CVar and C_CVar.GetCVarBool or GetCVarBool
Compat.GetCVarDefault = C_CVar and C_CVar.GetCVarDefault or GetCVarDefault
Compat.IsRestrictedContext = function()
    -- Chat messaging and some unit APIs are locked in Midnight encounters.
    return C_ChatInfo and C_ChatInfo.InChatMessagingLockdown and C_ChatInfo.InChatMessagingLockdown() or false
end
