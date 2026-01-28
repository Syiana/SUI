local Module = SUI:NewModule("UnitFrames.Combat");

function Module:OnEnable()
    local db = SUI.db.profile.unitframes.combaticon

    if (db) then
        -- Target Combat Icon
        CTT = CreateFrame("Frame")
        CTT:SetPoint("CENTER", TargetFrame, "RIGHT", 10, 0)
        CTT:SetSize(25, 25)
        CTT.t = CTT:CreateTexture(nil, "BORDER")
        CTT.t:SetAllPoints()
        CTT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
        CTT:Hide()

        -- Focus Combat Icon
        CFT = CreateFrame("Frame")
        CFT:SetPoint("CENTER", FocusFrame, "RIGHT", 10, 0)
        CFT:SetSize(25, 25)
        CFT.t = CFT:CreateTexture(nil, "BORDER")
        CFT.t:SetAllPoints()
        CFT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
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
                    UpdateCombatIcons()
                end
            else
                UpdateCombatIcons()
            end
        end)
        
        -- Initial update
        UpdateCombatIcons()
    end
end
