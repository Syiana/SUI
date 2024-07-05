-- credits to https://www.curseforge.com/wow/addons/inspect-ilvl by ianpend

local Module = SUI:NewModule("General.Inspect");
function Module:OnEnable()
    local db = {
        ilvl = SUI.db.profile.general.display.ilvl,
        module = SUI.db.profile.modules.general
    }

    if (db.ilvl and db.module) then
        local alreadyInitialized = false
        local Slots = {
            "HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "WristSlot",
            "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot",
            "Trinket0Slot", "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot", "RangedSlot"
        }

        local SlotIDs = {}
        for _, slotName in ipairs(Slots) do
            local id = GetInventorySlotInfo(slotName)
            SlotIDs[slotName] = id
        end
        local ItemLinks = {}
        local InspectFrameList = {}
        local InspectFontStrings = {}

        local itemsLeft = {
            [1] = true,
            [2] = true,
            [3] = true,
            [5] = true,
            [9] = true,
            [15] = true
        }

        local itemsRight = {
            [6] = true,
            [7] = true,
            [8] = true,
            [10] = true,
            [11] = true,
            [12] = true,
            [13] = true,
            [14] = true
        }


        local function initialize()
            if InspectModelFrame == nil then
                return
            end

            InspectFrameList = {
                InspectHeadSlot, InspectNeckSlot, InspectShoulderSlot, InspectBackSlot, InspectChestSlot,
                InspectWristSlot,
                InspectHandsSlot, InspectWaistSlot, InspectLegsSlot, InspectFeetSlot, InspectFinger0Slot,
                InspectFinger1Slot,
                InspectTrinket0Slot, InspectTrinket1Slot, InspectMainHandSlot, InspectSecondaryHandSlot,
                InspectRangedSlot
            }

            for _, f in ipairs(InspectFrameList) do
                local frameName = f:GetName()
                InspectFontStrings[frameName] = f:CreateFontString(nil, "OVERLAY", "SystemFont_Outline")
                InspectFontStrings[frameName]:SetPoint("TOP", 0, -2)
                InspectFontStrings[frameName]:SetTextColor(0, 1, 0)
            end

            alreadyInitialized = true
        end


        -- Heirloom gear uses the level of the inspecting player; this changes it to the inspected player
        local ITEMLINK_PATTERN_LINKLEVEL = "(item:" .. ("[^:]*:"):rep(8) .. ")(%d*)(.+)";
        local function FixHeirloomLevel(link, level)
            return (link and level) and link:gsub(ITEMLINK_PATTERN_LINKLEVEL, "%1" .. level .. "%3") or link;
        end


        local function scanGear()
            local level = UnitLevel(InspectFrame.unit)
            for _, slotName in ipairs(Slots) do
                local link = GetInventoryItemLink(InspectFrame.unit, SlotIDs[slotName])
                ItemLinks[slotName] = FixHeirloomLevel(link, level)
            end
        end

        local function updateText()
            if InspectModelFrame == nil then
                return
            end

            for _, slotName in ipairs(Slots) do
                local itemiLvlText = ""
                local frameName = "Inspect" .. slotName
                local slotilvl = ""

                -- Enchant Texts
                if not (_G[frameName].Enchant) then
                    _G[frameName].Enchant = InspectPaperDollItemsFrame:CreateFontString(frameName.."Enchant", "OVERLAY")
                    _G[frameName].Enchant:SetTextColor(0, 1, 0, 1)
                    _G[frameName].Enchant:SetJustifyH("LEFT")
                    _G[frameName].Enchant:SetJustifyV("TOP")
                    _G[frameName].Enchant:SetFont(FONT, 11, 'OUTLINE')
                end

                -- Socket Frames
                if not (_G[frameName].Socket1 and _G[frameName].Socket2 and _G[frameName].Socket3) then
                    _G[frameName].Socket1 = InspectPaperDollItemsFrame:CreateFontString(frameName.."Socket1", "OVERLAY")
                    _G[frameName].Socket2 = InspectPaperDollItemsFrame:CreateFontString(frameName.."Socket2", "OVERLAY")
                    _G[frameName].Socket3 = InspectPaperDollItemsFrame:CreateFontString(frameName.."Socket3", "OVERLAY")

                    _G[frameName].Socket1:SetFont(FONT, 13, 'OUTLINE')
                    _G[frameName].Socket2:SetFont(FONT, 13, 'OUTLINE')
                    _G[frameName].Socket3:SetFont(FONT, 13, 'OUTLINE')
                end

                if frameName and ItemLinks[slotName] then
                    slotilvl = GetDetailedItemLevelInfo(ItemLinks[slotName])
                    local enchantID = ParseItemLink(ItemLinks[slotName]).enchantID
                    local socket1 = ParseItemLink(ItemLinks[slotName]).socket1
                    local socket2 = ParseItemLink(ItemLinks[slotName]).socket2
                    local socket3 = ParseItemLink(ItemLinks[slotName]).socket3
                    local emptySockets = EmptySockets(ItemLinks[slotName])

                    -- Set Enchant-Text & Socket positions
                    if (itemsLeft[SlotIDs[slotName]]) then
                        _G[frameName].Enchant:SetPoint("TOPLEFT", _G[frameName], "TOPLEFT", 40, 0)
                        _G[frameName].Socket1:SetPoint("TOPLEFT", _G[frameName], "TOPLEFT", 42, -12)
                        _G[frameName].Socket2:SetPoint("RIGHT", _G[frameName].Socket1, "RIGHT", 14.5, 0)
                        _G[frameName].Socket3:SetPoint("RIGHT", _G[frameName].Socket2, "RIGHT", 14.5, 0)
                    elseif (itemsRight[SlotIDs[slotName]]) then
                        _G[frameName].Enchant:SetPoint("TOPRIGHT", _G[frameName], "TOPRIGHT", -40, 0)
                        _G[frameName].Socket1:SetPoint("TOPRIGHT", _G[frameName], "TOPRIGHT", -40, -12)
                        _G[frameName].Socket2:SetPoint("LEFT", _G[frameName].Socket1, "LEFT", -14, 0)
                        _G[frameName].Socket3:SetPoint("LEFT", _G[frameName].Socket2, "LEFT", -14, 0)
                    elseif (SlotIDs[slotName] == 16) then
                        _G[frameName].Enchant:SetPoint("BOTTOMRIGHT", _G[frameName], "BOTTOMRIGHT", -40, 0)
                        _G[frameName].Socket1:SetPoint("TOP", _G[frameName], "TOP", 0, 35)
                    elseif (SlotIDs[slotName] == 17) then
                        _G[frameName].Enchant:SetPoint("TOP", _G[frameName], "TOP", 0, 20)
                        _G[frameName].Socket1:SetPoint("TOP", _G[frameName], "TOP", 0, 35)
                    elseif (SlotIDs[slotName] == 18) then
                        _G[frameName].Enchant:SetPoint("BOTTOMRIGHT", _G[frameName], "BOTTOMRIGHT", 105, 0)
                        _G[frameName].Socket1:SetPoint("TOPRIGHT", _G[frameName], "TOPRIGHT", 20, -10)
                    end

                    if (enchantID) then
                        if (GetEnchantNameByID[enchantID]) then
                            _G[frameName].Enchant:SetTextColor(0, 1, 0, 1)
                            _G[frameName].Enchant:SetText(GetEnchantNameByID[enchantID])
                        end
                    else
                        if (NoEnchantText(ItemLinks[slotName], SlotIDs[slotName], false, InspectFrame.unit)) then
                            _G[frameName].Enchant:SetTextColor(1, 0, 0, 1)
                            _G[frameName].Enchant:SetText("No Enchant")
                        else
                            _G[frameName].Enchant:SetText("")
                        end
                    end

                    if (socket1) then
                        _G[frameName].Socket1:SetText(SocketTexture(socket1))
                    else
                        if (emptySockets[1]) then
                            local texture = EmptySocketTextures[emptySockets[1]]
                            if (texture) then
                                _G[frameName].Socket1:SetText("\124T"..texture..":0\124t")
                            else
                                _G[frameName].Socket1:SetText("\124T458977:0\124t")
                            end
                        else
                            _G[frameName].Socket1:SetText("")
                        end
                    end
                    if (socket2) then
                        _G[frameName].Socket2:SetText(SocketTexture(socket2))
                    else
                        if (emptySockets[2]) then
                            local texture = EmptySocketTextures[emptySockets[2]]
                            if (texture) then
                                _G[frameName].Socket2:SetText("\124T"..texture..":0\124t")
                            else
                                _G[frameName].Socket2:SetText("\124T458977:0\124t")
                            end
                        else
                            _G[frameName].Socket2:SetText("")
                        end
                    end
                    if (socket3) then
                        _G[frameName].Socket3:SetText(SocketTexture(socket3))
                    else
                        if (emptySockets[3]) then
                            local texture = EmptySocketTextures[emptySockets[3]]
                            if (texture) then
                                _G[frameName].Socket3:SetText("\124T"..texture..":0\124t")
                            else
                                _G[frameName].Socket3:SetText("\124T458977:0\124t")
                            end
                        else
                            _G[frameName].Socket3:SetText("")
                        end
                    end

                    local _, _, quality, _, _, _, _, _, _, _ = C_Item.GetItemInfo(ItemLinks[slotName])
                    if (quality) then
                        local hex = select(4,GetItemQualityColor(quality))
                        itemiLvlText = "|c"..hex..slotilvl.."|r"
                    else
                        itemiLvlText = slotilvl
                    end
                    InspectFontStrings[frameName]:SetText(itemiLvlText)
                else
                    if (frameName) then
                        InspectFontStrings[frameName]:SetText("")
                        _G[frameName].Enchant:SetText("")
                        _G[frameName].Socket1:SetText("")
                        _G[frameName].Socket2:SetText("")
                        _G[frameName].Socket3:SetText("")
                    end
                end
            end
        end


        local function main()
            -- Check if unit exists
            if not (InspectFrame and InspectFrame.unit) then return end

            -- Check if fontstrings have been already initialized
            if not (alreadyInitialized) then
                initialize()
            end

            InspectModelFrameRotateLeftButton:Hide()
            InspectModelFrameRotateRightButton:Hide()

            scanGear()
            updateText()
        end
        local inspectEventHandler = CreateFrame("Frame", nil, UIParent)
        inspectEventHandler:RegisterEvent("INSPECT_READY")
        inspectEventHandler:SetScript("OnEvent", main)

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_InspectUI" then
                InspectPaperDollItemsFrame:HookScript("OnUpdate", function()
                    if not (InspectFrame and InspectFrame.unit) then return end
                    scanGear()
                    updateText()
                end)
            end
        end)

        local function newTarget()
            if InspectModelFrame == nil then
                return
            end
            if InspectFrame:IsVisible() and CanInspect("target") then
                InspectUnit("target")
            end
        end
        local newTargetEventHandler = CreateFrame("Frame", nil, UIParent)
        newTargetEventHandler:RegisterEvent("PLAYER_TARGET_CHANGED")
        newTargetEventHandler:SetScript("OnEvent", newTarget)
    end
end
