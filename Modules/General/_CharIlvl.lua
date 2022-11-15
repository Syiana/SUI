-- credits to https://www.curseforge.com/wow/addons/Character-ilvl by ianpend

local Module = SUI:NewModule("General.CharIlvl");
function Module:OnEnable()
    local db = SUI.db.profile.general.display.ilvl
    if (db) then
        local equipped = {} -- Table to store equiped items
        local itemSlot = CreateFrame("Frame", nil, _G.PaperDollFrame)
        local S_ITEM_LEVEL = "^" .. gsub(ITEM_LEVEL, "%%d", "(%%d+)")
        local scantip = CreateFrame("GameTooltip", "iLvlScanningTooltip", nil, "GameTooltipTemplate")
        scantip:SetOwner(UIParent, "ANCHOR_NONE")

        local function createFontStrings()
            local function _stringFactory(parent)
                local s = itemSlot:CreateFontString(nil, "OVERLAY", "SystemFont_Outline")
                s:SetPoint("CENTER", parent, "BOTTOM", 0, 8)

                return s
            end

            itemSlot:SetFrameLevel(_G.CharacterHeadSlot:GetFrameLevel())

            itemSlot[1] = _stringFactory(_G.CharacterHeadSlot)
            itemSlot[2] = _stringFactory(_G.CharacterNeckSlot)
            itemSlot[3] = _stringFactory(_G.CharacterShoulderSlot)
            itemSlot[15] = _stringFactory(_G.CharacterBackSlot)
            itemSlot[5] = _stringFactory(_G.CharacterChestSlot)
            itemSlot[9] = _stringFactory(_G.CharacterWristSlot)

            itemSlot[10] = _stringFactory(_G.CharacterHandsSlot)
            itemSlot[6] = _stringFactory(_G.CharacterWaistSlot)
            itemSlot[7] = _stringFactory(_G.CharacterLegsSlot)
            itemSlot[8] = _stringFactory(_G.CharacterFeetSlot)
            itemSlot[11] = _stringFactory(_G.CharacterFinger0Slot)
            itemSlot[12] = _stringFactory(_G.CharacterFinger1Slot)
            itemSlot[13] = _stringFactory(_G.CharacterTrinket0Slot)
            itemSlot[14] = _stringFactory(_G.CharacterTrinket1Slot)

            itemSlot[16] = _stringFactory(_G.CharacterMainHandSlot)
            itemSlot[17] = _stringFactory(_G.CharacterSecondaryHandSlot)

            itemSlot:Hide()
        end

        local function getItemLevel(slotId, unit)
            local itemLevel
            local hasItem = scantip:SetInventoryItem(unit, slotId)
            if not hasItem then return nil end

            for i = 2, scantip:NumLines() do
                local text = _G["iLvlScanningTooltipTextLeft"..i]:GetText()
                if text and text ~= "" then
                    itemLevel = itemLevel or strmatch(text, S_ITEM_LEVEL)

                    if itemLevel then
                        return tonumber(itemLevel)
                    end
                end
            end

            return itemLevel
        end

        local function updateItems(unit, frame)
            for i = 1, 17 do
                local itemLink = GetInventoryItemLink(unit, i)
                if i ~= 4 then
                    if itemLink then
                        local _, _, quality = GetItemInfo(itemLink)
                        local _, _, _, hex = GetItemQualityColor(quality)
                        local itemLevel = getItemLevel(i, "player")
                        itemLevel = itemLevel or ""
                        frame[i]:SetFormattedText('|c%s%s|r', hex, itemLevel or '?')
                    else
                        frame[i]:SetText("")
                    end
                end
            end
        end

        local function OnEvent(self, event, ...) -- Event handler
            if event == "ADDON_LOADED" and (...) == "Blizzard_InspectUI" then
                self:UnregisterEvent(event)

                -- iLevel number frame for Inspect
                createFontStrings()
                createFontStrings = nil
            elseif event == "PLAYER_LOGIN" then
                self:UnregisterEvent(event)

                createFontStrings()
                createFontStrings = nil

                _G.PaperDollFrame:HookScript("OnShow", function(self)
                    itemSlot:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
                    itemSlot:RegisterEvent("ARTIFACT_UPDATE")
                    itemSlot:RegisterEvent("SOCKET_INFO_UPDATE")
                    itemSlot:RegisterEvent("COMBAT_RATING_UPDATE")
                    updateItems("player", itemSlot)
                    itemSlot:Show()
                end)

                _G.PaperDollFrame:HookScript("OnHide", function(self)
                    itemSlot:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
                    itemSlot:UnregisterEvent("ARTIFACT_UPDATE")
                    itemSlot:UnregisterEvent("SOCKET_INFO_UPDATE")
                    itemSlot:UnregisterEvent("COMBAT_RATING_UPDATE")
                    itemSlot:Hide()
                end)
            elseif event == "PLAYER_EQUIPMENT_CHANGED" or event == "ITEM_UPGRADE_MASTER_UPDATE"
            or event == "ARTIFACT_UPDATE" or event == "SOCKET_INFO_UPDATE" or event == "COMBAT_RATING_UPDATE" then
                if (...) == 16 then
                    equipped[16] = nil
                    equipped[17] = nil
                end

                updateItems("player", itemSlot)
            end
        end
        itemSlot:SetScript("OnEvent", OnEvent)
        itemSlot:GetScript("OnEvent")(itemSlot, "PLAYER_LOGIN")
    end
end