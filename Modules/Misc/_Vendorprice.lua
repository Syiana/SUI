local Module = SUI:NewModule("Misc.Vendorprice");

function Module:OnEnable()
  local db = SUI.db.profile.misc.vendorprice
  if (db) then
    VendorPrice = {}
    local VP = VendorPrice

    local SELL_PRICE_TEXT = format("%s:", SELL_PRICE)

    local CharacterBags = {}
    for i = CONTAINER_BAG_OFFSET+1, 23 do
        CharacterBags[i] = true
    end

    local firstBankBag = ContainerIDToInventoryID(NUM_BAG_SLOTS + 1)
    local lastBankBag = ContainerIDToInventoryID(NUM_BAG_SLOTS + NUM_BANKBAGSLOTS)
    for i = firstBankBag, lastBankBag do
        CharacterBags[i] = true
    end

    local function IsMerchant(tt)
        if MerchantFrame:IsShown() then
            local name = tt:GetOwner():GetName()
            if name then -- bagnon sanity check
                return not (name:find("Character") or name:find("TradeSkill"))
            end
        end
    end

    local function ShouldShowPrice(tt, source)
        return not IsMerchant(tt) --and not VP:HasAuctionator(source)
    end

    -- OnTooltipSetItem fires twice for recipes
    local function CheckRecipe(tt, classID, isOnTooltipSetItem)
        if classID == LE_ITEM_CLASS_RECIPE and isOnTooltipSetItem then
            tt.isFirstMoneyLine = not tt.isFirstMoneyLine
            return tt.isFirstMoneyLine
        end
    end

    function VP:SetPrice(tt, source, count, item, isOnTooltipSetItem)
        if ShouldShowPrice(tt, source) then
            count = count or 1
            item = item or select(2, tt:GetItem())
            if item then
                local sellPrice, classID = select(11, GetItemInfo(item))
                if sellPrice and sellPrice > 0 and not CheckRecipe(tt, classID, isOnTooltipSetItem) then
                    if IsShiftKeyDown() and count > 1 then
                        SetTooltipMoney(tt, sellPrice, nil, SELL_PRICE_TEXT)
                    else
                        SetTooltipMoney(tt, sellPrice * count, nil, SELL_PRICE_TEXT)
                    end
                    tt:Show()
                end
            end
        end
    end

    local SetItem = {
        SetAction = function(tt, slot)
            if GetActionInfo(slot) == "item" then
                VP:SetPrice(tt, "SetAction", GetActionCount(slot))
            end
        end,
        SetAuctionItem = function(tt, auctionType, index)
            local _, _, count = GetAuctionItemInfo(auctionType, index)
            VP:SetPrice(tt, "SetAuctionItem", count)
        end,
        SetAuctionSellItem = function(tt)
            local _, _, count = GetAuctionSellItemInfo()
            VP:SetPrice(tt, "SetAuctionSellItem", count)
        end,
        SetBagItem = function(tt, bag, slot)
            local _, count = GetContainerItemInfo(bag, slot)
            VP:SetPrice(tt, "SetBagItem", count)
        end,
        --SetBagItemChild
        --SetBuybackItem -- already shown
        --SetCompareItem
        SetCraftItem = function(tt, index, reagent)
            local _, _, count = GetCraftReagentInfo(index, reagent)
            -- otherwise returns an empty link
            local itemLink = GetCraftReagentItemLink(index, reagent)
            VP:SetPrice(tt, "SetCraftItem", count, itemLink)
        end,
        SetCraftSpell = function(tt)
            VP:SetPrice(tt, "SetCraftSpell")
        end,
        --SetHyperlink -- item information is not readily available
        SetInboxItem = function(tt, messageIndex, attachIndex)
            local count, itemID
            if attachIndex then
                count = select(4, GetInboxItem(messageIndex, attachIndex))
            else
                count, itemID = select(14, GetInboxHeaderInfo(messageIndex))
            end
            VP:SetPrice(tt, "SetInboxItem", count, itemID)
        end,
        SetInventoryItem = function(tt, unit, slot)
            local count
            if not CharacterBags[slot] then
                count = GetInventoryItemCount(unit, slot)
            end
            VP:SetPrice(tt, "SetInventoryItem", count)
        end,
        --SetInventoryItemByID
        --SetItemByID
        SetLootItem = function(tt, slot)
            local _, _, count = GetLootSlotInfo(slot)
            VP:SetPrice(tt, "SetLootItem", count)
        end,
        SetLootRollItem = function(tt, rollID)
            local _, _, count = GetLootRollItemInfo(rollID)
            VP:SetPrice(tt, "SetLootRollItem", count)
        end,
        --SetMerchantCostItem -- alternate currency
        --SetMerchantItem -- already shown
        SetQuestItem = function(tt, questType, index)
            local _, _, count = GetQuestItemInfo(questType, index)
            VP:SetPrice(tt, "SetQuestItem", count)
        end,
        SetQuestLogItem = function(tt, _, index)
            local _, _, count = GetQuestLogRewardInfo(index)
            VP:SetPrice(tt, "SetQuestLogItem", count)
        end,
        --SetRecipeReagentItem -- retail
        --SetRecipeResultItem -- retail
        SetSendMailItem = function(tt, index)
            local count = select(4, GetSendMailItem(index))
            VP:SetPrice(tt, "SetSendMailItem", count)
        end,
        SetTradePlayerItem = function(tt, index)
            local _, _, count = GetTradePlayerItemInfo(index)
            VP:SetPrice(tt, "SetTradePlayerItem", count)
        end,
        SetTradeSkillItem = function(tt, index, reagent)
            local count
            if reagent then
                count = select(3, GetTradeSkillReagentInfo(index, reagent))
            else -- show minimum instead of maximum count
                count = GetTradeSkillNumMade(index)
            end
            VP:SetPrice(tt, "SetTradeSkillItem", count)
        end,
        SetTradeTargetItem = function(tt, index)
            local _, _, count = GetTradeTargetItemInfo(index)
            VP:SetPrice(tt, "SetTradeTargetItem", count)
        end,
        SetTrainerService = function(tt, index)
            VP:SetPrice(tt, "SetTrainerService")
        end,
    }

    for method, func in pairs(SetItem) do
        hooksecurefunc(GameTooltip, method, func)
    end

    ItemRefTooltip:HookScript("OnTooltipSetItem", function(tt)
        local item = select(2, tt:GetItem())
        if item then --and not VP:HasAuctionator("OnTooltipSetItem") then
            local sellPrice, classID = select(11, GetItemInfo(item))
            if sellPrice and sellPrice > 0 and not CheckRecipe(tt, classID, true) then
                SetTooltipMoney(tt, sellPrice, nil, SELL_PRICE_TEXT)
            end
        end
    end)
  end
end