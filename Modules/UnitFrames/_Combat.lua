local Module = SUI:NewModule("UnitFrames.Combat");
local CTT
local CFT

function Module:RefreshVisibility()
    local enabled = SUI.db.profile.unitframes.combaticon
    if not CTT or not CFT then
        return
    end

    if not enabled then
        CTT:Hide()
        CFT:Hide()
        return
    end

    if UnitExists("target") and UnitAffectingCombat("target") then
        CTT:Show()
    else
        CTT:Hide()
    end

    if UnitExists("focus") and UnitAffectingCombat("focus") then
        CFT:Show()
    else
        CFT:Hide()
    end
end

function Module:OnEnable()
    local db = SUI.db.profile.unitframes.combaticon

    if (db) then
        -- Target Combat Icon
        CTT = CTT or CreateFrame("Frame")
        CTT:SetPoint("CENTER", TargetFrame, "RIGHT", 10, 0)
        CTT:SetSize(25, 25)
        if not CTT.t then
            CTT.t = CTT:CreateTexture(nil, "BORDER")
            CTT.t:SetAllPoints()
            CTT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
        end
        CTT:Hide()

        -- Focus Combat Icon
        CFT = CFT or CreateFrame("Frame")
        CFT:SetPoint("CENTER", FocusFrame, "RIGHT", 10, 0)
        CFT:SetSize(25, 25)
        if not CFT.t then
            CFT.t = CFT:CreateTexture(nil, "BORDER")
            CFT.t:SetAllPoints()
            CFT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
        end
        CFT:Hide()

        -- Performance optimized: Use events instead of OnUpdate
        local combatFrame = CreateFrame("Frame")
        combatFrame:RegisterEvent("UNIT_COMBAT")
        combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
        combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        combatFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
        combatFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
        
        local function UpdateCombatIcons()
            -- Update target combat icon
            if UnitExists("target") and UnitAffectingCombat("target") then
                CTT:Show()
            else
                CTT:Hide()
            end
            
            -- Update focus combat icon
            if UnitExists("focus") and UnitAffectingCombat("focus") then
                CFT:Show()
            else
                CFT:Hide()
            end
        end

        combatFrame:SetScript("OnEvent", function(self, event, unit)
            if event == "UNIT_COMBAT" then
                if unit == "target" or unit == "focus" then
                    Module:RefreshVisibility()
                end
            else
                Module:RefreshVisibility()
            end
        end)
        
        -- Initial update
        Module:RefreshVisibility()
    end
end
