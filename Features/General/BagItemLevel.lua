--[[
    SUI 2.0 - Features/General/BagItemLevel.lua

    Item level on weapons and armour in the bags and at merchants, coloured
    by quality. Hooks the bag update functions of each client (retail
    container frame mixins or the classic ContainerFrame_Update).
]]

local _, ns = ...
local SUI = ns.SUI

local Compat = SUI.Compat
local _G = _G

local F = SUI:NewFeature("General.BagItemLevel", {
    category = "general",
    toggle = "display.ilvl",
})

local WEAPON, ARMOR = 2, 4 -- Enum.ItemClass
local strings = {} -- button -> font string
local location     -- reused ItemLocation (retail and modern classic)
local GetItemInfoInstant

local function label(button)
    local fs = strings[button]
    if not fs then
        fs = button:CreateFontString(nil, "OVERLAY")
        fs:SetFont(SUI.db.profile.general.font, 13, "OUTLINE")
        fs:SetPoint("CENTER", button, "BOTTOM", 0, 8)
        strings[button] = fs
    end
    return fs
end

local function isGear(link)
    local classID = select(6, GetItemInfoInstant(link))
    return classID == WEAPON or classID == ARMOR
end

local function show(button, level, quality)
    if not level or level <= 1 then
        if strings[button] then
            strings[button]:SetText("")
        end
        return
    end
    local fs = label(button)
    local r, g, b = 1, 1, 1
    if quality then
        r, g, b = Compat.GetItemQualityColor(quality)
    end
    fs:SetTextColor(r, g, b)
    fs:SetText(level)
    fs:Show()
end

local function updateSlot(button, bag, slot)
    local quality, link = Compat.GetContainerItem(bag, slot)
    if not link or not isGear(link) then
        if strings[button] then
            strings[button]:SetText("")
        end
        return
    end
    local level
    if location then
        location:SetBagAndSlot(bag, slot)
        level = C_Item.DoesItemExist(location) and C_Item.GetCurrentItemLevel(location)
    end
    show(button, level or Compat.GetDetailedItemLevelInfo(link), quality)
end

local function updateMixinFrame(frame)
    for _, button in frame:EnumerateValidItems() do
        updateSlot(button, button:GetBagID(), button:GetID())
    end
end

local function updateClassicFrame(frame)
    local bag, name = frame:GetID(), frame:GetName()
    for i = 1, frame.size or 0 do
        local button = _G[name .. "Item" .. i]
        if button then
            updateSlot(button, bag, button:GetID())
        end
    end
end

local function updateMerchant()
    if MerchantFrame.selectedTab == 2 then
        return
    end
    local perPage = MERCHANT_ITEMS_PER_PAGE or 10
    local numItems = GetMerchantNumItems()
    for i = 1, perPage do
        local button = _G["MerchantItem" .. i .. "ItemButton"]
        local index = (MerchantFrame.page - 1) * perPage + i
        if button then
            local link = index <= numItems and GetMerchantItemLink(index)
            if link and isGear(link) then
                local _, _, quality, level = Compat.GetItemInfo(link)
                show(button, quality and quality > 1 and level, quality)
            elseif strings[button] then
                strings[button]:SetText("")
            end
        end
    end
end

function F:OnLoad()
    GetItemInfoInstant = SUI.Compat.GetItemInfoInstant
    if Enum and Enum.ItemClass then
        WEAPON, ARMOR = Enum.ItemClass.Weapon, Enum.ItemClass.Armor
    end
    if ItemLocation and ItemLocation.CreateEmpty and C_Item and C_Item.GetCurrentItemLevel and C_Item.DoesItemExist then
        location = ItemLocation:CreateEmpty()
    end

    if ContainerFrameCombinedBags and ContainerFrameCombinedBags.UpdateItems then
        self:Hook(ContainerFrameCombinedBags, "UpdateItems", updateMixinFrame)
        local frames = ContainerFrameContainer and ContainerFrameContainer.ContainerFrames or {}
        for i = 1, #frames do
            self:Hook(frames[i], "UpdateItems", updateMixinFrame)
        end
    elseif ContainerFrame_Update then
        self:Hook("ContainerFrame_Update", updateClassicFrame)
    end
    if MerchantFrame_UpdateMerchantInfo then
        self:Hook("MerchantFrame_UpdateMerchantInfo", updateMerchant)
    end
end

function F:OnRefresh(key)
    if key == "font" then
        for _, fs in next, strings do
            fs:SetFont(self.db.font, 13, "OUTLINE")
        end
    end
end

function F:OnDisable()
    for _, fs in next, strings do
        fs:Hide()
    end
end
