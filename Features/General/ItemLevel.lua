--[[
    SUI 2.0 - Features/General/ItemLevel.lua

    Item level, enchant, gem and durability hints next to the equipment
    slots of the character and inspect frames, plus the inspected player's
    average item level. Everything is refreshed from Blizzard's slot update
    functions and inventory events; nothing polls. Enchant text and sockets
    need C_TooltipInfo and are skipped on clients without it.
    Idea and layout from SUI 1.x (credits: BetterCharacterPanel).
]]

local _, ns = ...
local SUI = ns.SUI

local Compat = SUI.Compat
local _G = _G
local strfind, strsub, strmatch, gsub = string.find, string.sub, string.match, string.gsub
local tonumber, floor = tonumber, math.floor
local GetInventoryItemLink, GetInventoryItemQuality = GetInventoryItemLink, GetInventoryItemQuality

local F = SUI:NewFeature("General.ItemLevel", {
    category = "general",
    toggle = "display.ilvl",
})

-- Inventory slot ids (INVSLOT_*), identical on every client.
local HEAD, NECK, SHOULDER, CHEST, WAIST, LEGS, FEET, WRIST, HAND = 1, 2, 3, 5, 6, 7, 8, 9, 10
local FINGER1, FINGER2, TRINKET1, TRINKET2, BACK, MAINHAND, OFFHAND, RANGED = 11, 12, 13, 14, 15, 16, 17, 18

local NUM_SOCKETS = 4
local MAX_ENCHANT_LENGTH = 18 -- +12 for a colour code, like 1.x
local DURABILITY_TEXTURE = [[Interface\TARGETINGFRAME\UI-StatusBar]]

local layout      -- slot id -> "left" | "right" | "center"
local enchantable -- expansion -> { [slot] = true }
local sockets     -- expansion -> { [slot] = required gem count }
local hasRanged
local displays = {}  -- button -> display frame
local pendingGems = {}

-- Short enchant names, applied in alphabetical order like 1.x did.
local SHORT = {
    ["Stamina"] = "Stam", ["Intellect"] = "Int", ["Agility"] = "Agi", ["Strength"] = "Str",
    ["Mastery"] = "Mast", ["Versatility"] = "Vers", ["Critical Strike"] = "Crit", ["Haste"] = "Haste",
    ["Avoidance"] = "Avoid", ["Minor Speed Increase"] = "Speed", ["Homebound Speed"] = "Speed & HS Red.",
    ["Plainsrunner's Breeze"] = "Speed", ["Graceful Avoid"] = "Avoid", ["Regenerative Leech"] = "Leech",
    ["Watcher's Loam"] = "Stam", ["Rider's Reassurance"] = "Mount Speed", ["Accelerated Agility"] = "Speed & Agi",
    ["Reserve of Int"] = "Mana & Int", ["Sustained Str"] = "Stam & Str", ["Waking Stats"] = "Primary Stat",
    ["Cavalry's March"] = "Mount Speed", ["Scout's March"] = "Speed", ["Defender's March"] = "Stam",
    ["Stormrider's Agi"] = "Agi & Speed", ["Council's Intellect"] = "Int & Mana",
    ["Crystalline Radiance"] = "Primary Stat", ["Oathsworn's Strength"] = "Str & Stam",
    ["Chant of Armored Avoid"] = "Avoid", ["Chant of Armored Leech"] = "Leech",
    ["Chant of Armored Speed"] = "Speed", ["Chant of Winged Grace"] = "Avoid & FallDmg",
    ["Chant of Leeching Fangs"] = "Leech & Recup", ["Chant of Burrowing Rapidity"] = "Speed & HScd",
    ["Cursed Haste"] = "Haste & |cffcc0000-Vers|r", ["Cursed Crit"] = "Crit & |cffcc0000-Haste|r",
    ["Cursed Mastery"] = "Mast & |cffcc0000-Crit|r", ["Cursed Versatility"] = "Vers & |cffcc0000-Mast|r",
    ["Shadowed Belt Clasp"] = "Stamina", ["Incandescent Essence"] = "Essence",
    ["+"] = "",
}
local shortKeys = {}

local function replacePlain(text, find, replacement)
    local start = 1
    while true do
        local a, b = strfind(text, find, start, true)
        if not a then
            return text
        end
        text = strsub(text, 1, a - 1) .. replacement .. strsub(text, b + 1)
        start = a + #replacement
    end
end

local function shorten(text)
    for i = 1, #shortKeys do
        local key = shortKeys[i]
        text = replacePlain(text, key, SHORT[key])
    end
    return text
end

-- Tooltip data -------------------------------------------------------------------
local enchantPattern

-- Returns enchantText, qualityAtlas for an equipped item, or nil.
local function getEnchant(data)
    local lines = data.lines
    for i = 1, #lines do
        local text = lines[i].leftText
        local enchant = text and Compat.CanAccess(text) and strmatch(text, enchantPattern)
        if enchant then
            local _, colored = strmatch(enchant, "|cn(.-):(.-)|r")
            if colored then
                return shorten(colored)
            end
            local plain, atlas = strmatch(enchant, "(.-)%s*|A:(.-):20:20|a")
            return shorten(plain or enchant), atlas
        end
    end
end

-- Fills the socket textures from tooltip lines; returns the count shown.
local function fillSockets(display, data)
    local gemType = Enum and Enum.TooltipDataLineType and Enum.TooltipDataLineType.GemSocket or 3
    local count = 0
    local lines = data.lines
    for i = 1, #lines do
        local line = lines[i]
        if line.type == gemType and count < NUM_SOCKETS then
            count = count + 1
            local texture = display.sockets[count]
            texture:SetTexture(line.gemIcon or ("Interface\\ItemSocketingFrame\\UI-EmptySocket-" .. (line.socketType or "Prismatic")))
            texture:SetVertexColor(1, 1, 1)
            texture:Show()
        end
    end
    return count
end

-- Gems stream in after login; remember the ones we still wait for.
local function gemsReady(link)
    local ready = true
    local g1, g2, g3, g4 = strmatch(link, "item:[^:]*:[^:]*:([^:]*):([^:]*):([^:]*):([^:]*)")
    for i = 1, 4 do
        local id = tonumber((i == 1 and g1) or (i == 2 and g2) or (i == 3 and g3) or g4)
        if id and id > 0 then
            local cached
            if C_Item and C_Item.IsItemDataCachedByID then
                cached = C_Item.IsItemDataCachedByID(id)
            else
                cached = Compat.GetItemInfo(id) ~= nil
            end
            if not cached then
                ready = false
                pendingGems[id] = true
                if C_Item and C_Item.RequestLoadItemDataByID then
                    C_Item.RequestLoadItemDataByID(id)
                end
            end
        end
    end
    return ready
end

local function canEnchant(unit, slot, expansion)
    local slots = expansion and enchantable[expansion]
    if slots and slots[slot] then
        return true
    end
    if slot == OFFHAND and slots then
        local link = GetInventoryItemLink(unit, slot)
        local equipLoc = link and select(4, SUI.Compat.GetItemInfoInstant(link))
        return equipLoc ~= nil and equipLoc ~= "INVTYPE_HOLDABLE" and equipLoc ~= "INVTYPE_SHIELD"
    end
    return false
end

-- Display frames -------------------------------------------------------------------
local function createDisplay(button)
    local display = CreateFrame("Frame", nil, button:GetParent())
    display:SetFrameLevel(button:GetFrameLevel() + 1)

    display.ilvl = display:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline")
    display.enchant = display:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline")
    display.enchant:SetTextColor(0, 1, 0)

    display.sockets = {}
    for i = 1, NUM_SOCKETS do
        local texture = display:CreateTexture(nil, "OVERLAY")
        texture:SetSize(14, 14)
        texture:Hide()
        display.sockets[i] = texture
    end

    local bar = CreateFrame("StatusBar", nil, display)
    bar:SetMinMaxValues(0, 1)
    bar:SetStatusBarTexture(DURABILITY_TEXTURE)
    local barTexture = bar:GetStatusBarTexture()
    if barTexture then
        barTexture:SetHorizTile(false)
        barTexture:SetVertTile(false)
    end
    bar:Hide()
    display.durability = bar

    -- Anchors -----------------------------------------------------------------
    local slot = button:GetID()
    local side = layout[slot]
    local s = display.sockets
    local function chain(first, point, relative, dir)
        s[1]:SetPoint(point, first, relative, 3 * dir, 1)
        for i = 2, NUM_SOCKETS do
            s[i]:SetPoint(point, s[i - 1], relative, 2 * dir, 0)
        end
    end

    if side == "left" then
        display:SetPoint("TOPLEFT", button, "TOPRIGHT")
        display:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT")
        display:SetWidth(100)
        display.ilvl:SetPoint("BOTTOMLEFT", display, "BOTTOMLEFT", 10, 2)
        display.enchant:SetPoint("TOPLEFT", display, "TOPLEFT", 10, -7)
        chain(display.ilvl, "LEFT", "RIGHT", 1)
        bar:SetWidth(2.3)
        bar:SetOrientation("VERTICAL")
        bar:SetPoint("TOPLEFT", button, "TOPLEFT", -6, 0)
        bar:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -6, 0)
    elseif side == "right" then
        display:SetPoint("TOPRIGHT", button, "TOPLEFT")
        display:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT")
        display:SetWidth(100)
        display.ilvl:SetPoint("BOTTOMRIGHT", display, "BOTTOMRIGHT", -10, 2)
        display.enchant:SetPoint("TOPRIGHT", display, "TOPRIGHT", -10, -7)
        chain(display.ilvl, "RIGHT", "LEFT", -1)
        bar:SetWidth(1.2)
        bar:SetOrientation("VERTICAL")
        bar:SetPoint("TOPRIGHT", button, "TOPRIGHT", 4, 0)
        bar:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, 0)
    else
        display:SetAllPoints(button)
        display.ilvl:SetPoint("BOTTOM", button, "TOP", 0, 7)
        bar:SetHeight(2)
        bar:SetOrientation("HORIZONTAL")
        bar:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, -2)
        bar:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, -2)
        if slot == MAINHAND then
            display.enchant:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -5, 0)
            chain(display.ilvl, "RIGHT", "LEFT", -1)
        elseif slot == OFFHAND and hasRanged then
            display.enchant:SetPoint("BOTTOM", display.ilvl, "TOP", 0, 3)
            chain(display.ilvl, "LEFT", "RIGHT", 1)
        else
            display.enchant:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 5, 0)
            chain(display.ilvl, "LEFT", "RIGHT", 1)
        end
    end

    displays[button] = display
    return display
end

local function durabilityColor(perc)
    if perc < 0.5 then
        return 1, perc * 2, 0
    end
    return (1 - perc) * 2, 1, 0
end

local function updateButton(button, unit)
    local slot = button:GetID()
    if not unit or not layout[slot] then
        return
    end
    local display = displays[button] or createDisplay(button)
    display:Show()

    local link = GetInventoryItemLink(unit, slot)
    if link ~= display.link or unit ~= display.unit or not display.gemsReady then
        display.link, display.unit = link, unit
        display.gemsReady = not link or gemsReady(link)

        local level = link and Compat.GetDetailedItemLevelInfo(link)
        if level then
            local quality = GetInventoryItemQuality(unit, slot)
            local r, g, b = 1, 1, 1
            if quality then
                r, g, b = Compat.GetItemQualityColor(quality)
            end
            display.ilvl:SetTextColor(r, g, b)
            display.ilvl:SetText(level)
        else
            display.ilvl:SetText("")
        end

        local data = link and C_TooltipInfo and C_TooltipInfo.GetInventoryItem(unit, slot)
        local enchant, atlas
        local shown = 0
        if data and data.lines then
            enchant, atlas = getEnchant(data)
            shown = fillSockets(display, data)
        end

        local expansion = GetExpansionForLevel and GetExpansionForLevel(UnitLevel(unit))
        if enchant then
            enchant = strsub(enchant, 1, strfind(enchant, "|c", 1, true) and MAX_ENCHANT_LENGTH + 12 or MAX_ENCHANT_LENGTH)
            if atlas then
                local icon = "|A:" .. atlas .. ":12:12|a"
                enchant = slot == OFFHAND and (icon .. enchant) or (enchant .. icon)
            end
            display.enchant:SetText(enchant)
        elseif link and data and canEnchant(unit, slot, expansion)
            and IsLevelAtEffectiveMaxLevel and IsLevelAtEffectiveMaxLevel(UnitLevel(unit)) then
            display.enchant:SetText("|cffff0000No Enchant|r")
        else
            display.enchant:SetText("")
        end

        -- Required but empty sockets in red.
        local required = link and expansion and sockets[expansion] and sockets[expansion][slot] or 0
        for i = shown + 1, NUM_SOCKETS do
            local texture = display.sockets[i]
            if i <= required then
                texture:SetTexture("Interface\\ItemSocketingFrame\\UI-EmptySocket-Red")
                texture:SetVertexColor(1, 0, 0)
                texture:Show()
            else
                texture:Hide()
            end
        end
    end

    local bar = display.durability
    local perc
    if unit == "player" then
        local current, maximum = GetInventoryItemDurability(slot)
        perc = current and maximum and maximum > 0 and current / maximum
    end
    if perc ~= display.perc then
        display.perc = perc
        if perc and perc < 1 then
            bar:SetValue(perc)
            bar:SetStatusBarColor(durabilityColor(perc))
            bar:Show()
        else
            bar:Hide()
        end
    end
end

-- Inspect ------------------------------------------------------------------------------
local function inspectAverage(unit)
    if C_PaperDollInfo and C_PaperDollInfo.GetInspectItemLevel then
        return C_PaperDollInfo.GetInspectItemLevel(unit)
    end
    local total, count = 0, 0
    for slot in next, layout do
        local link = GetInventoryItemLink(unit, slot)
        local level = link and Compat.GetDetailedItemLevelInfo(link)
        if level and level > 0 then
            total, count = total + level, count + 1
        end
    end
    return count > 0 and total / count or 0
end

local function updateInspectLevel()
    local unit = InspectFrame and InspectFrame.unit
    local parent = InspectPaperDollItemsFrame or InspectPaperDollFrame
    if not unit or not parent then
        return
    end
    local label = F.inspectLevel
    if not label then
        -- 1.x: centred in an 80x47 box below the top right corner
        label = parent:CreateFontString(nil, "OVERLAY", _G.GameFontHighlightOutline22 and "GameFontHighlightOutline22" or "GameFontHighlightOutline")
        label:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -20)
        label:SetPoint("BOTTOMLEFT", parent, "TOPRIGHT", -80, -67)
        F.inspectLevel = label
    end
    local level = inspectAverage(unit)
    if not Compat.CanAccess(level) then
        return
    end
    -- 1.x colour steps (retail item levels)
    local r, g, b = 0.98, 0.98, 0.98
    if SUI.IsRetail then
        if level >= 483 then
            r, g, b = 1, 0.5, 0
        elseif level >= 466 then
            r, g, b = 0.64, 0.21, 0.93
        elseif level >= 449 then
            r, g, b = 0, 0.44, 0.87
        elseif level >= 432 then
            r, g, b = 0.12, 1, 0
        end
    end
    label:SetTextColor(r, g, b)
    label:SetFormattedText("%d", floor(level))
    label:Show()
end

-- Inspect talents button ------------------------------------------------------------------
-- 1.x restyled it as a tab next to InspectFrameTab3. Blizzard's button
-- template repaints its textures on show, press and enable; instead of
-- removing those scripts the art is re-applied after them.
local TAB_ART = { Left = "uiframe-tab-left", Right = "uiframe-tab-right", Middle = "_uiframe-tab-center" }

local function paintTab(button)
    local left, right, middle = button.Left, button.Right, button.Middle
    for key, atlas in next, TAB_ART do
        local texture = button[key]
        texture:SetTexture(nil)
        texture:SetTexCoord(0, 1, 0, 1)
        texture:ClearAllPoints()
        texture:SetAtlas(atlas, true)
        texture:SetHeight(36)
    end
    left:SetPoint("TOPLEFT")
    right:SetPoint("TOPRIGHT", 6, 0)
    middle:SetPoint("LEFT", left, "RIGHT")
    middle:SetPoint("RIGHT", right, "LEFT")
    if button.Text then
        button.Text:ClearAllPoints()
        button.Text:SetPoint("CENTER", 0, 2)
        button.Text:SetHeight(10)
    end
    button:ClearAllPoints()
    button:SetPoint("LEFT", InspectFrameTab3, "RIGHT", 3, 0)
end

local function styleTalentsButton()
    local button = InspectPaperDollItemsFrame and InspectPaperDollItemsFrame.InspectTalents
    if F.talentsStyled or not button or not InspectFrameTab3 or not (button.Left and button.Right and button.Middle) then
        return
    end
    F.talentsStyled = true
    button:SetSize(72, 32)

    local highlights = {}
    for key, atlas in next, TAB_ART do
        local texture = button:CreateTexture()
        texture:SetAtlas(atlas, true)
        texture:SetAlpha(0.4)
        texture:SetBlendMode("ADD")
        texture:Hide()
        highlights[key] = texture
    end
    highlights.Left:SetPoint("TOPLEFT")
    highlights.Right:SetPoint("TOPRIGHT", 6, 0)
    highlights.Middle:SetPoint("LEFT", button.Left, "RIGHT")
    highlights.Middle:SetPoint("RIGHT", button.Right, "LEFT")

    button:SetNormalFontObject(GameFontNormalSmall)
    button:SetHighlightFontObject(GameFontHighlightSmall)
    if button.ClearHighlightTexture then
        button:ClearHighlightTexture()
    end
    paintTab(button)

    button:HookScript("OnEnter", function()
        for _, texture in next, highlights do
            texture:Show()
        end
    end)
    button:HookScript("OnLeave", function()
        for _, texture in next, highlights do
            texture:Hide()
        end
    end)
    for _, script in next, { "OnMouseDown", "OnMouseUp", "OnShow", "OnEnable", "OnDisable" } do
        button:HookScript(script, paintTab)
    end
end

-- Feature -------------------------------------------------------------------------------
local CHARACTER_SLOTS = {
    "Head", "Neck", "Shoulder", "Back", "Chest", "Wrist", "Hands", "Waist", "Legs", "Feet",
    "Finger0", "Finger1", "Trinket0", "Trinket1", "MainHand", "SecondaryHand", "Ranged",
}

local function refreshCharacter()
    F.refreshQueued = false
    if not CharacterFrame or not CharacterFrame:IsShown() then
        return
    end
    for i = 1, #CHARACTER_SLOTS do
        local button = _G["Character" .. CHARACTER_SLOTS[i] .. "Slot"]
        if button then
            updateButton(button, "player")
        end
    end
end

local function queueRefresh()
    if not F.refreshQueued then
        F.refreshQueued = true
        F:After(0, refreshCharacter)
    end
end

function F:OnLoad()
    hasRanged = _G.CharacterRangedSlot ~= nil
    layout = {
        [HEAD] = "left", [NECK] = "left", [SHOULDER] = "left",
        [BACK] = "left", [CHEST] = "left", [WRIST] = "left",
        [HAND] = "right", [WAIST] = "right", [LEGS] = "right",
        [FEET] = "right", [FINGER1] = "right", [FINGER2] = "right",
        [TRINKET1] = "right", [TRINKET2] = "right",
        [MAINHAND] = "center", [OFFHAND] = "center",
    }
    if hasRanged then
        layout[RANGED] = "center"
    end
    -- Keyed by GetExpansionForLevel (retail only in practice).
    enchantable = {
        [9] = {
            [HEAD] = true, [BACK] = true, [CHEST] = true, [WRIST] = true,
            [WAIST] = true, [LEGS] = true, [FEET] = true, [MAINHAND] = true,
            [FINGER1] = true, [FINGER2] = true,
        },
        [10] = {
            [BACK] = true, [CHEST] = true, [WRIST] = true, [LEGS] = true,
            [FEET] = true, [MAINHAND] = true, [FINGER1] = true, [FINGER2] = true,
        },
    }
    sockets = {
        [9] = { [NECK] = 3 },
        [10] = { [NECK] = 2, [FINGER1] = 2, [FINGER2] = 2 },
    }

    for key in next, SHORT do
        shortKeys[#shortKeys + 1] = key
    end
    table.sort(shortKeys)
    local line = ENCHANTED_TOOLTIP_LINE
    enchantPattern = gsub(type(line) == "string" and line or "Enchanted: %s", "%%s", "(.*)")

    if PaperDollItemSlotButton_Update then
        self:Hook("PaperDollItemSlotButton_Update", function(button)
            updateButton(button, "player")
        end)
    end

    -- Two decimals for the equipped item level (retail stats pane).
    if PaperDollFrame_SetItemLevel then
        self:Hook("PaperDollFrame_SetItemLevel", function(statFrame, unit)
            if unit ~= "player" or not statFrame or not statFrame.Value then
                return
            end
            local _, equipped = GetAverageItemLevel()
            if equipped then
                statFrame.Value:SetFormattedText(equipped == floor(equipped) and "%d" or "%.2f", equipped)
            end
        end)
    end

    -- Hooks installed after OnLoad cannot use F:Hook; gate them the same way.
    SUI:OnAddonLoaded("Blizzard_InspectUI", function()
        if F.enabled then
            styleTalentsButton()
        end
        if InspectPaperDollItemSlotButton_Update then
            hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
                if F.enabled then
                    updateButton(button, InspectFrame and InspectFrame.unit)
                end
            end)
        end
        if InspectPaperDollFrame_SetLevel then
            hooksecurefunc("InspectPaperDollFrame_SetLevel", function()
                if F.enabled then
                    updateInspectLevel()
                end
            end)
        end
    end)
end

function F:OnEnable()
    self:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", queueRefresh, "player")
    self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", queueRefresh)
    self:RegisterEvent("SOCKET_INFO_UPDATE", queueRefresh)
    self:RegisterEvent("GET_ITEM_INFO_RECEIVED", function(_, _, itemID)
        if itemID and pendingGems[itemID] then
            pendingGems[itemID] = nil
            queueRefresh()
        end
    end)
    -- Ask for the gems we are wearing so the sockets are ready on first open.
    for slot in next, layout do
        local link = GetInventoryItemLink("player", slot)
        if link then
            gemsReady(link)
        end
    end
    refreshCharacter()
    if Compat.IsAddOnLoaded("Blizzard_InspectUI") then
        styleTalentsButton()
    end
end

function F:OnDisable()
    for _, display in next, displays do
        display:Hide()
        -- false/-1 never match a real value, so the next update rescans
        display.link, display.perc = false, -1
    end
    if self.inspectLevel then
        self.inspectLevel:Hide()
    end
end
