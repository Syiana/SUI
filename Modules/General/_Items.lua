local Module = SUI:NewModule("General.Items");

function Module:OnEnable()
  local db = SUI.db.profile.general.display.ilvl

  if (db) then
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
        local text = _G["iLvlScanningTooltipTextLeft"..i]:GetText()
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
      for i = 1, 17 do
        local color = '|cFFFFFF00'
        local itemLink = GetInventoryItemLink(unit, i)
        if i ~= 4 and ((frame == f and (equiped[i] ~= itemLink or frame[i]:GetText() == nil or itemLink == nil and frame[i]:GetText() ~= "")) or frame == g) then
          if frame == f then
            equiped[i] = itemLink
          end

          local delay = false
          if itemLink then
            local _, _, quality = GetItemInfo(itemLink)
            if (quality == 6) and (i == 16 or i == 17) then
              local relics = {select(4, strsplit(":", itemLink))}
              for i = 1, 3 do
                local relicID = relics[i] ~= "" and relics[i]
                local relicLink = select(2, GetItemGem(itemLink, i))
                if relicID and not relicLink then
                  delay = true
                end
              end
              if delay then
                C_Timer.After(0.1, function()
                  local realItemLevel = _getRealItemLevel(i, unit)
                  realItemLevel = realItemLevel or ""
                  frame[i]:SetText(color .. realItemLevel)
                end)
              end
            end
          end

          local realItemLevel = _getRealItemLevel(i, unit)
          realItemLevel = realItemLevel or ""
          if realItemLevel and realItemLevel == 1 then
            realItemLevel = ""
          end
          frame[i]:SetText(color .. realItemLevel)
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
          f:RegisterEvent("ARTIFACT_UPDATE")
          f:RegisterEvent("SOCKET_INFO_UPDATE")
          f:RegisterEvent("COMBAT_RATING_UPDATE")
          _updateItems("player", f)
          f:Show()
        end)

        _G.PaperDollFrame:HookScript("OnHide", function(self)
          f:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
          f:UnregisterEvent("ARTIFACT_UPDATE")
          f:UnregisterEvent("SOCKET_INFO_UPDATE")
          f:UnregisterEvent("COMBAT_RATING_UPDATE")
          f:Hide()
        end)
      elseif event == "PLAYER_EQUIPMENT_CHANGED" or event == "ITEM_UPGRADE_MASTER_UPDATE"
      or event == "ARTIFACT_UPDATE" or event == "SOCKET_INFO_UPDATE" or event == "COMBAT_RATING_UPDATE" then
        if (...) == 16 then
          equiped[16] = nil
          equiped[17] = nil
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

        local button = _G["MerchantItem"..i.."ItemButton"]
        if button and button:IsShown() then
          if not button.text then
            button.text = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline")
            button.text:SetPoint("TOPLEFT", 1, -1)
            button.text:SetTextColor(1, 1, 0)
          else
            button.text:SetText("")
          end

          local itemLink = GetMerchantItemLink(index)
          if itemLink then
            local _, _, quality, itemlevel, _, _, _, _, _, _, _, itemClassID = GetItemInfo(itemLink)
            if (itemlevel and itemlevel > 1) and (quality and quality > 1) and (itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR) then
              button.text:SetText(itemlevel)
            end
          end
        end
      end
    end
    hooksecurefunc("MerchantFrame_UpdateMerchantInfo", MerchantItemlevel)

    function SetContainerItemLevel(button, ItemLink)
        if not button then
            print("error")
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
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(ItemLink)
            local name, _ = GetItemSpell(ItemLink)
            local _, equipped, _ = GetAverageItemLevel()
        if itemLevel == nil then return end
            if itemLevel >= (98 * equipped / 100) then
                button.levelString:SetTextColor(0, 1, 0)
            else
                button.levelString:SetTextColor(1, 1, 1)
        end
        if itemEquipLoc >= " " and itemLevel > 0 and itemRarity > 1 then
          if itemRarity < 7 then
            button.levelString:SetText(itemLevel)
          end
            else
                button.levelString:SetText("")
        end
        else
            button.levelString:SetText("")
        end
    end
    hooksecurefunc("ContainerFrame_Update",function(self)
            local name = self:GetName()
            for i = 1, self.size do
                local button = _G[name .. "Item" .. i]
                SetContainerItemLevel(button, GetContainerItemLink(self:GetID(), button:GetID()))
            end
        end
    )
  end
end