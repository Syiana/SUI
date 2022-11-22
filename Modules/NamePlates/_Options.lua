local Module = SUI:NewModule("NamePlates.Size");

function Module:OnEnable()
    local db = SUI.db.profile.nameplates
    if db then
        local function updateCvars()
            if db.stackingmode then
                SetCVar("nameplateMotion", 1)            -- Set Nameplate to Stacking-Mode
                SetCVar("nameplateOverlapH", 0.5)        -- Set Nameplate Stacking Distance Horizontal
                SetCVar("nameplateOverlapV", 0.5)        -- Set Nameplate Stacking Distance Vertical
                SetCVar("nameplateMinScale", 1)          -- Set Nameplate Stacking Distance Vertical
            end

            if db.height and db.width then
                SetCVar("NamePlateVerticalScale", db.height)    -- Set Nameplate Height
                SetCVar("NamePlateHorizontalScale", db.width)   -- Set Nameplate Width
            end
        end
    
        -- Apply Nameplate settings
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("CVAR_UPDATE")
        frame:SetScript("OnEvent", updateCvars)
    end
end