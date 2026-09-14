local Module = SUI:NewModule("General.BagIlvl");

function Module:OnEnable()
    local db = SUI.db.profile.general.display.ilvl

    if (db) then
        local function MerchantItemlevel()
            local numItems = GetMerchantNumItems()

            for i = 1, MERCHANT_ITEMS_PER_PAGE do
                local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
                if index > numItems then return end

                local button = _G["MerchantItem" .. i .. "ItemButton"]
                if button and button:IsShown() then
                    if not button.text then
                        button.text = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline")
                        button.text:SetPoint("CENTER", button, "BOTTOM", 0, 8)
                    else
                        button.text:SetText("")
                    end

                    local itemLink = GetMerchantItemLink(index)
                    if itemLink then
                        local _, _, quality, itemlevel, _, _, _, _, _, _, _, itemClassID = GetItemInfo(itemLink)
                        if (itemlevel and itemlevel > 1) and (quality and quality > 1) and
                            (itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR) then
                            local _, _, _, color = C_Item.GetItemQualityColor(quality)
                            button.text:SetFormattedText('|c%s%s|r', color, itemlevel or '?')
                        end
                    end
                end
            end
        end

        hooksecurefunc("MerchantFrame_UpdateMerchantInfo", MerchantItemlevel)

        function CreateItemLevelString(button)
            button.levelString = button:CreateFontString(nil, "OVERLAY")
            button.levelString:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
            button.levelString:SetPoint("CENTER", button, "BOTTOM", 0, 8)
        end

        function CheckContainerItems(item)
            local _, _, _, equipLoc, _, itemClass, itemSubClass = C_Item.GetItemInfoInstant(item:GetItemID())
            return (
                itemClass == Enum.ItemClass.Weapon or
                    itemClass == Enum.ItemClass.Armor or
                    (itemClass == Enum.ItemClass.Gem and itemSubClass == Enum.ItemGemSubclass.Artifactrelic)
                )
        end

        function UpdateBagButton(button, item)
            if item:IsItemEmpty() then return end
            item:ContinueOnItemLoad(function()
                if not CheckContainerItems(item) then return end
                local itemID = item:GetItemID()
                local link = item:GetItemLink()
                local quality = item:GetItemQuality()
                local _, _, _, equipLoc, _, itemClass, itemSubClass = C_Item.GetItemInfoInstant(itemID)
                local minLevel = link and select(5, C_Item.GetItemInfo(link or itemID))
                if not item:GetCurrentItemLevel() then
                    button.levelString:Hide()
                else
                    CreateItemLevelString(button)
                    local _, _, _, hex = C_Item.GetItemQualityColor(quality)
                    button.levelString:SetFormattedText('|c%s%s|r', hex, item:GetCurrentItemLevel() or '?')
                    button.levelString:Show()
                end
            end)
        end

        function UpdateContainerButton(button, bag, slot)
            if button.levelString then button.levelString:Hide() end

            local item = Item:CreateFromBagAndSlot(bag, slot or button:GetID())
            UpdateBagButton(button, item)
        end

        if _G.ContainerFrame_Update then
            hooksecurefunc("ContainerFrame_Update", function(container)
                local bag = container:GetID()
                local name = container:GetName()
                for i = 1, container.size, 1 do
                    local button = _G[name .. "Item" .. i]
                    UpdateContainerButton(button, bag)
                end
            end)
        else
            local update = function(frame)
                for _, itemButton in frame:EnumerateValidItems() do
                    UpdateContainerButton(itemButton, itemButton:GetBagID(), itemButton:GetID())
                end
            end
            hooksecurefunc(ContainerFrameCombinedBags, "UpdateItems", update)
            for _, frame in ipairs(ContainerFrameContainer.ContainerFrames) do
                hooksecurefunc(frame, "UpdateItems", update)
            end
        end
    end
end
