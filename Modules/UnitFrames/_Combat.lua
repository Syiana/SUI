local Module = SUI:NewModule("UnitFrames.Combat");

function Module:OnEnable()
    local db = SUI.db.profile.unitframes.combaticon

    if (db) then
        CTT = CreateFrame("Frame")
        CTT:SetPoint("CENTER", TargetFrame, "RIGHT", 10, 0)
        CTT:SetSize(25, 25)
        CTT.t = CTT:CreateTexture(nil, BORDER)
        CTT.t:SetAllPoints()
        CTT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
        CTT:Hide()

        local function FrameOnUpdate(self)
            if UnitAffectingCombat("target") then
                self:Show()
            else
                self:Hide()
            end
        end

        local g = CreateFrame("Frame")
        g:SetScript("OnUpdate", function(self)
            FrameOnUpdate(CTT)
        end)
        CFT = CreateFrame("Frame")
        CFT:SetPoint("CENTER", FocusFrame, "RIGHT", 10, 0)
        CFT:SetSize(25, 25)
        CFT.t = CFT:CreateTexture(nil, BORDER)
        CFT.t:SetAllPoints()
        CFT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
        CFT:Hide()

        local function FrameOnUpdate(self)
            if UnitAffectingCombat("focus") then
                self:Show()
            else
                self:Hide()
            end
        end

        local g = CreateFrame("Frame")
        g:SetScript("OnUpdate", function(self)
            FrameOnUpdate(CFT)
        end)
    end
end
