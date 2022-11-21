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

            SetCVar("NamePlateVerticalScale", db.height)    -- Set Nameplate Height
            SetCVar("NamePlateHorizontalScale", db.width)   -- Set Nameplate Width
        end
    
        -- Nameplate settings
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:RegisterEvent("PLAYER_LOGIN")
        frame:RegisterEvent("CVAR_UPDATE")
        frame:SetScript("OnEvent", function()
            updateCvars()
        end)
    end
end