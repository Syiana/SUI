local Module = SUI:NewModule("General.AvgIlvl");

function Module:OnEnable()
    -- NOT IN USE ATM
    local db = SUI.db.profile.general.display.avgilvl

    if (db) then
        local alreadyInitialized = false
        local InspectFontStrings = {}

        local function InitializeAvergageIlvl()
            if InspectModelFrame == nil then
                return
            end

            InspectFontStrings["avg"] = InspectModelFrame:CreateFontString(nil, "OVERLAY")
            InspectFontStrings["text"] = InspectModelFrame:CreateFontString(nil, "OVERLAY")
            InspectFontStrings["avg"]:SetPoint("BOTTOM", 148, -25)
            InspectFontStrings["text"]:SetPoint("BOTTOM", 95, -25)
            InspectFontStrings["avg"]:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")
            InspectFontStrings["text"]:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")

            alreadyInitialized = true
        end

        local function updateAvgIlvl()
            if InspectModelFrame == nil then
                return
            end

            local avgilvl = C_PaperDollInfo.GetInspectItemLevel("target")
            InspectFontStrings["text"]:SetText("Average iLvl:")
            InspectFontStrings["avg"]:SetText(avgilvl)
        end

        local function AverageIlvl()
            if CanInspect("target") then
                if not (alreadyInitialized) then
                    InitializeAvergageIlvl()
                end
                updateAvgIlvl()
            end
        end
        local inspectEventHandler = CreateFrame("Frame", nil, UIParent)
        inspectEventHandler:RegisterEvent("INSPECT_READY")
        inspectEventHandler:SetScript("OnEvent", AverageIlvl)


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
