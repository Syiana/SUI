local Module = SUI:NewModule("NamePlates.Size");

function Module:OnEnable()
    if C_AddOns.IsAddOnLoaded('Plater') or C_AddOns.IsAddOnLoaded('TidyPlates_ThreatPlates') or C_AddOns.IsAddOnLoaded('TidyPlates') or C_AddOns.IsAddOnLoaded('Kui_Nameplates') then return end
    local db = SUI.db.profile.nameplates
    if db and db.style ~= 'Default' then
        local function updateCvars()
            if db.stackingmode then
                SetCVar("nameplateMotion", 1)     -- Set Nameplate to Stacking-Mode
                SetCVar("nameplateOverlapH", 0.5) -- Set Nameplate Stacking Distance Horizontal
                SetCVar("nameplateOverlapV", 0.5) -- Set Nameplate Stacking Distance Vertical
                SetCVar("nameplateMinScale", 1)   -- Set Nameplate Stacking Distance Vertical
            end

            if db.height and db.width then
                SetCVar("NamePlateVerticalScale", db.height)  -- Set Nameplate Height
                SetCVar("NamePlateHorizontalScale", db.width) -- Set Nameplate Width
            end
        end

        -- Apply Nameplate settings
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_LOGIN")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:RegisterEvent("PLAYER_LOGOUT")
        frame:SetScript("OnEvent", updateCvars)

        if db.debuffs then
            local debuffs = CreateFrame("Frame")
            local events = {}

            function events:NAME_PLATE_UNIT_ADDED(plate)
                local unitId = plate
                local nameplate = C_NamePlate.GetNamePlateForUnit(unitId)
                local frame = nameplate.UnitFrame
                if not nameplate or frame:IsForbidden() then return end
                --frame.BuffFrame:ClearAllPoints()
                frame.BuffFrame:SetAlpha(0)
                frame.BuffFrame:Hide()
                frame.BuffFrame.UpdateBuffs = function() end
            end

            for b, u in pairs(events) do
                debuffs:RegisterEvent(b)
            end

            debuffs:SetScript("OnEvent", function(self, event, ...) events[event](self, ...) end)
        end
    end
end
