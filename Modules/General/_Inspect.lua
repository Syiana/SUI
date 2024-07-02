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
            local level = UnitLevel("target")
            for _, slotName in ipairs(Slots) do
                local link = GetInventoryItemLink("target", SlotIDs[slotName])
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
                if ItemLinks[slotName] then
                    slotilvl = GetDetailedItemLevelInfo(ItemLinks[slotName])
                    local _, _, quality, _, _, _, _, _, _, _ = C_Item.GetItemInfo(ItemLinks[slotName])
                    if (quality) then
                        local hex = select(4,GetItemQualityColor(quality))
                        itemiLvlText = "|c"..hex..slotilvl.."|r"
                    else
                        itemiLvlText = slotilvl
                    end
                    InspectFontStrings[frameName]:SetText(itemiLvlText)
                else
                    InspectFontStrings[frameName]:SetText("")
                end
            end
        end


        local function main()
            if CanInspect("target") then
                if not (alreadyInitialized) then
                    initialize()
                end
            end
        end
        local inspectEventHandler = CreateFrame("Frame", nil, UIParent)
        inspectEventHandler:RegisterEvent("INSPECT_READY")
        inspectEventHandler:SetScript("OnEvent", main)

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_InspectUI" then
                InspectPaperDollItemsFrame:HookScript("OnUpdate", function()
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
