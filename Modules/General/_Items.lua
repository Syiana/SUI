local Module = SUI:NewModule("General.Items");

function Module:OnEnable()
    local db = {
        ilvl = SUI.db.profile.general.display.ilvl,
        module = SUI.db.profile.modules.general
    }

    local simpleTypes = {
        enchantID        = 2,
        gem1             = 3,
        gem2             = 4,
        gem3             = 5,
        gem4             = 6
    }

    local function ParseItemLink(link)
        local _, linkOptions = LinkUtil.ExtractLink(link)
        local item = { strsplit(":", linkOptions) }
        local t = {}

        for k, v in pairs(simpleTypes) do
            t[k] = tonumber(item[v])
        end

        for i = 1, 4 do
            local gem = tonumber(item[i + 2])
            if gem then
                t.gems = t.gems or {}
                t.gems[i] = gem
            end
        end

        local idx = 13
        local numBonusIDs = tonumber(item[idx])
        if numBonusIDs then
            t.bonusIDs = {}
            for i = 1, numBonusIDs do
                t.bonusIDs[i] = tonumber(item[idx + i])
            end
        end
        idx = idx + (numBonusIDs or 0) + 1

        local numModifiers = tonumber(item[idx])
        if numModifiers then
            t.modifiers = {}
            for i = 1, numModifiers do
                local offset = i * 2
                t.modifiers[i] = {
                    tonumber(item[idx + offset - 1]),
                    tonumber(item[idx + offset])
                }
            end
            idx = idx + numModifiers * 2 + 1
        else
            idx = idx + 1
        end

        for i = 1, 3 do
            local relicNumBonusIDs = tonumber(item[idx])
            if relicNumBonusIDs then
                t.relicBonusIDs = t.relicBonusIDs or {}
                t.relicBonusIDs[i] = {}
                for j = 1, relicNumBonusIDs do
                    t.relicBonusIDs[i][j] = tonumber(item[idx + j])
                end
            end
            idx = idx + (relicNumBonusIDs or 0) + 1
        end

        local crafterGUID = item[idx]
        if #crafterGUID > 0 then
            t.crafterGUID = crafterGUID
        end
        idx = idx + 1

        t.extraEnchantID = tonumber(item[idx])

        return t
    end

    if (db.ilvl and db.module) then
        local equiped = {} -- Table to store equiped items

        local f = CreateFrame("Frame", nil, _G.PaperDollFrame)
        local g = CreateFrame("Frame", nil, _G.InspectPaperDollFrame)

        local S_ITEM_LEVEL = "^" .. gsub(ITEM_LEVEL, "%%d", "(%%d+)")

        local scantip = CreateFrame("GameTooltip", "iLvlScanningTooltip", nil, "GameTooltipTemplate")
        scantip:SetOwner(UIParent, "ANCHOR_NONE")

        local function _getRealItemLevel(slotId, unit)
            local realItemLevel
            local hasItem = scantip:SetInventoryItem(unit, slotId)
            if not hasItem then return nil end

            for i = 2, scantip:NumLines() do
                local text = _G["iLvlScanningTooltipTextLeft" .. i]:GetText()
                if text and text ~= "" then
                    realItemLevel = realItemLevel or strmatch(text, S_ITEM_LEVEL)

                    if realItemLevel then
                        return tonumber(realItemLevel)
                    end
                end
            end

            return realItemLevel
        end

        local function _updateItems(unit, frame)
            for i = 1, 18 do
                local itemLink = GetInventoryItemLink(unit, i)
                local quality = GetInventoryItemQuality(unit, i)

                if i ~= 4 and ((frame == f and (equiped[i] ~= itemLink or frame[i]:GetText() == nil or itemLink == nil and frame[i]:GetText() ~= "")) or frame == g) then
                    if frame == f then
                        equiped[i] = itemLink
                    end

                    if itemLink then
                        local realItemLevel = _getRealItemLevel(i, unit)
                        realItemLevel = realItemLevel or ""

                        local itemiLvlText = "";
                        if (quality) then
                            local hex = select(4, GetItemQualityColor(quality));
                            itemiLvlText = "|c" .. hex .. realItemLevel .. "|r";
                        else
                            itemiLvlText = realItemLevel;
                        end
                        frame[i]:SetText(itemiLvlText)
                    else
                        frame[i]:SetText("")
                    end
                end
            end
        end

        local function _createStrings()
            local function _stringFactory(parent)
                local s = f:CreateFontString(nil, "OVERLAY", "SystemFont_Outline")
                s:SetPoint("TOP", parent, "TOP", 0, -2)

                return s
            end

            f:SetFrameLevel(_G.CharacterHeadSlot:GetFrameLevel())

            f[1] = _stringFactory(_G.CharacterHeadSlot)
            f[2] = _stringFactory(_G.CharacterNeckSlot)
            f[3] = _stringFactory(_G.CharacterShoulderSlot)
            f[15] = _stringFactory(_G.CharacterBackSlot)
            f[5] = _stringFactory(_G.CharacterChestSlot)
            f[9] = _stringFactory(_G.CharacterWristSlot)

            f[10] = _stringFactory(_G.CharacterHandsSlot)
            f[6] = _stringFactory(_G.CharacterWaistSlot)
            f[7] = _stringFactory(_G.CharacterLegsSlot)
            f[8] = _stringFactory(_G.CharacterFeetSlot)
            f[11] = _stringFactory(_G.CharacterFinger0Slot)
            f[12] = _stringFactory(_G.CharacterFinger1Slot)
            f[13] = _stringFactory(_G.CharacterTrinket0Slot)
            f[14] = _stringFactory(_G.CharacterTrinket1Slot)

            f[16] = _stringFactory(_G.CharacterMainHandSlot)
            f[17] = _stringFactory(_G.CharacterSecondaryHandSlot)
            f[18] = _stringFactory(_G.CharacterRangedSlot)

            f:Hide()
        end

        local function _createGStrings()
            local function _stringFactory(parent)
                local s = g:CreateFontString(nil, "OVERLAY", "SystemFont_Outline")
                s:SetPoint("TOP", parent, "TOP", 0, -2)

                return s
            end

            g:SetFrameLevel(_G.InspectHeadSlot:GetFrameLevel())

            g[1] = _stringFactory(_G.InspectHeadSlot)
            g[2] = _stringFactory(_G.InspectNeckSlot)
            g[3] = _stringFactory(_G.InspectShoulderSlot)
            g[15] = _stringFactory(_G.InspectBackSlot)
            g[5] = _stringFactory(_G.InspectChestSlot)
            g[9] = _stringFactory(_G.InspectWristSlot)

            g[10] = _stringFactory(_G.InspectHandsSlot)
            g[6] = _stringFactory(_G.InspectWaistSlot)
            g[7] = _stringFactory(_G.InspectLegsSlot)
            g[8] = _stringFactory(_G.InspectFeetSlot)
            g[11] = _stringFactory(_G.InspectFinger0Slot)
            g[12] = _stringFactory(_G.InspectFinger1Slot)
            g[13] = _stringFactory(_G.InspectTrinket0Slot)
            g[14] = _stringFactory(_G.InspectTrinket1Slot)

            g[16] = _stringFactory(_G.InspectMainHandSlot)
            g[17] = _stringFactory(_G.InspectSecondaryHandSlot)
            g[18] = _stringFactory(_G.InspectRangedSlot)

            g:Hide()
        end

        local function OnEvent(self, event, ...) -- Event handler
            if event == "ADDON_LOADED" and (...) == "Blizzard_InspectUI" then
                self:UnregisterEvent(event)

                -- iLevel number frame for Inspect
                _createGStrings()
                _createGStrings = nil
            elseif event == "PLAYER_LOGIN" then
                self:UnregisterEvent(event)

                _createStrings()
                _createStrings = nil

                _G.PaperDollFrame:HookScript("OnShow", function(self)
                    f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
                    --f:RegisterEvent("ARTIFACT_UPDATE")
                    f:RegisterEvent("SOCKET_INFO_UPDATE")
                    f:RegisterEvent("COMBAT_RATING_UPDATE")
                    _updateItems("player", f)
                    f:Show()
                end)

                _G.PaperDollFrame:HookScript("OnHide", function(self)
                    f:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
                    --f:UnregisterEvent("ARTIFACT_UPDATE")
                    f:UnregisterEvent("SOCKET_INFO_UPDATE")
                    f:UnregisterEvent("COMBAT_RATING_UPDATE")
                    f:Hide()
                end)
            elseif event == "PLAYER_EQUIPMENT_CHANGED" or event == "ITEM_UPGRADE_MASTER_UPDATE"
                or event == "ARTIFACT_UPDATE" or event == "SOCKET_INFO_UPDATE" or event == "COMBAT_RATING_UPDATE" then
                if (...) == 16 then
                    equiped[16] = nil
                    equiped[17] = nil
                    equiped[18] = nil
                end
                _updateItems("player", f)
            end
        end
        f:SetScript("OnEvent", OnEvent)
        f:GetScript("OnEvent")(f, "PLAYER_LOGIN")

        local function MerchantItemlevel()
            local numItems = GetMerchantNumItems()

            for i = 1, MERCHANT_ITEMS_PER_PAGE do
                local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
                if index > numItems then return end

                local button = _G["MerchantItem" .. i .. "ItemButton"]
                if button and button:IsShown() then
                    if not button.text then
                        button.text = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline")
                        button.text:SetPoint("CENTER", button, "TOP", 0, -5)
                    else
                        button.text:SetText("")
                    end

                    local itemLink = GetMerchantItemLink(index)
                    if itemLink then
                        local _, _, quality, itemlevel, _, _, _, _, _, _, _, itemClassID = GetItemInfo(itemLink)

                        if (itemlevel > 100) then
                            local itemiLvlText = ""
                            if (quality) then
                                local hex = select(4, GetItemQualityColor(quality))
                                itemiLvlText = "|c" .. hex .. itemlevel .. "|r"
                            else
                                itemiLvlText = itemlevel
                            end
                            button.text:SetText(itemiLvlText)
                        end
                    end
                end
            end
        end
        hooksecurefunc("MerchantFrame_UpdateMerchantInfo", MerchantItemlevel)

        function SetContainerItemLevel(button, ItemLink)
            if not button then
                return
            end
            if not button.levelString then
                button.levelString = button:CreateFontString(nil, "OVERLAY")
                button.levelString:SetFont(STANDARD_TEXT_FONT, 12, "THICKOUTLINE")
                button.levelString:SetPoint("TOP")
            end
            if button.origItemLink ~= ItemLink then
                button.origItemLink = ItemLink
            else
                return
            end
            if ItemLink then
                local itemiLvlText = ""
                local ilvl = GetDetailedItemLevelInfo(ItemLink)
                local _, _, quality, _, _, _, _, _, _, _ = C_Item.GetItemInfo(ItemLink)
                --local quality = GetInventoryItemQuality(unit, slot)
                if (quality) then
                    local hex = select(4, GetItemQualityColor(quality))
                    itemiLvlText = "|c" .. hex .. ilvl .. "|r"
                else
                    itemiLvlText = ilvl
                end

                if (ilvl > 100) then
                    button.levelString:SetText(itemiLvlText)
                else
                    button.levelString:SetText("")
                end
            else
                button.levelString:SetText("")
            end
        end

        hooksecurefunc("ContainerFrame_Update", function(self)
            local name = self:GetName()
            for i = 1, self.size do
                local button = _G[name .. "Item" .. i]
                SetContainerItemLevel(button, C_Container.GetContainerItemLink(self:GetID(), button:GetID()))
            end
        end
        )
    end
end
