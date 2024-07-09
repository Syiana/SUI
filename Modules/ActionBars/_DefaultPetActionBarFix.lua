local Module = SUI:NewModule("ActionBars.DefaultPetActionBarFix");

function Module:OnEnable()
    local db = {
        style = SUI.db.profile.actionbar.style
    }

    if (db.style == 'Default') then
        hooksecurefunc(PetActionBarFrame, "UpdatePositionValues", function()
            if (MultiBarBottomLeft:IsShown()) then
                if (GetNumShapeshiftForms() > 0) then
                    local button = _G["StanceButton" .. GetNumShapeshiftForms()]
                    PetActionBarFrame:ClearAllPoints()
                    PetActionBarFrame:SetPoint("LEFT", button, "RIGHT", 19.7, 4.5)
                else
                    PetActionBarFrame:ClearAllPoints()
                    PetActionBarFrame:SetPoint("LEFT", MainMenuBar, "LEFT", 35.4, 90)
                end
            end
        end)
    end
end