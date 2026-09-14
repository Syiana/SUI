--[[
    SUI 2.0 - Features/General/Merchant.lua

    Vendor helpers: sell grey items, repair (own gold or guild bank) and buy a
    full stack with Alt-click. All of them only react while a merchant is open.
]]

local _, ns = ...
local SUI = ns.SUI

local Compat = SUI.Compat
local floor, format = math.floor, string.format

-- Sell greys ------------------------------------------------------------------
local Sell = SUI:NewFeature("General.Sell", {
    category = "general",
    toggle = "automation.sell",
})

function Sell:OnEnable()
    self:RegisterEvent("MERCHANT_SHOW", "SellJunk")
end

function Sell:SellJunk()
    local lastBag = tonumber(NUM_TOTAL_EQUIPPED_BAG_SLOTS) or Compat.NUM_BAG_SLOTS
    for bag = 0, lastBag do
        for slot = 1, Compat.GetContainerNumSlots(bag) or 0 do
            local quality, link, noValue = Compat.GetContainerItem(bag, slot)
            if link and quality == 0 and not noValue then
                Compat.UseContainerItem(bag, slot)
            end
        end
    end
end

-- Repair ------------------------------------------------------------------------
local Repair = SUI:NewFeature("General.Repair", {
    category = "general",
    toggle = "automation.repair", -- "Disabled" | "Player" | "Guild"
})

function Repair:OnEnable()
    self:RegisterEvent("MERCHANT_SHOW", "Repair")
end

function Repair:Repair()
    if not CanMerchantRepair() then
        return
    end
    local cost = GetRepairAllCost()
    if not cost or cost <= 0 then
        return
    end
    if self.db.automation.repair == "Guild" and IsInGuild() and CanGuildBankRepair and CanGuildBankRepair() then
        local available = GetGuildBankWithdrawMoney()
        local bank = GetGuildBankMoney()
        -- -1 means unlimited withdrawal (guild master)
        if available < 0 or available > bank then
            available = bank
        end
        if available >= cost then
            RepairAllItems(true)
            SUI:Print(format("Repair cost covered by guild bank: %.1fg", cost / 10000))
            return
        end
    end
    if GetMoney() >= cost then
        RepairAllItems()
        SUI:Print(format("Repair cost: %.1fg", cost / 10000))
    else
        SUI:Print("Not enough gold to cover the repair cost.")
    end
end

-- Stack buy -----------------------------------------------------------------------
local StackBuy = SUI:NewFeature("General.StackBuy", {
    category = "general",
    toggle = "automation.stackbuy",
})

local function merchantStackCount(index)
    if C_MerchantFrame and C_MerchantFrame.GetItemInfo then
        local info = C_MerchantFrame.GetItemInfo(index)
        return info and info.stackCount
    end
    local _, _, _, quantity = GetMerchantItemInfo(index)
    return quantity
end

function StackBuy:OnLoad()
    if not MerchantItemButton_OnModifiedClick then
        return
    end
    self:Hook("MerchantItemButton_OnModifiedClick", function(button)
        if not IsAltKeyDown() or not button or MerchantFrame.selectedTab == 2 then -- 2 = buyback
            return
        end
        local index = button:GetID()
        local link = GetMerchantItemLink(index)
        if not link then
            return
        end
        local maxStack = select(8, Compat.GetItemInfo(link))
        local quantity = merchantStackCount(index) or 1
        if maxStack and maxStack > 1 then
            BuyMerchantItem(index, floor(maxStack / quantity))
        end
    end)
end
