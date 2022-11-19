local Module = SUI:NewModule("NamePlates.Size");

function Module:OnEnable()
    local db = SUI.db.profile.nameplates

    if db.stackingmode then
        -- Nameplate settings
        local stackingMode = CreateFrame("Frame")
        stackingMode:RegisterEvent("CVAR_UPDATE")
        stackingMode:SetScript("OnEvent", function(_, event)
            SetCVar("nameplateMotion", 1)            -- Set Nameplate to Stacking-Mode
            SetCVar("nameplateOverlapH", 0.5)        -- Set Nameplate Stacking Distance Horizontal
            SetCVar("nameplateOverlapV", 0.5)        -- Set Nameplate Stacking Distance Vertical
            SetCVar("nameplateMinScale", 1)          -- Set Nameplate Stacking Distance Vertical
        end)
    end

    -- Nameplate settings
    local size = CreateFrame("Frame")
    size:RegisterEvent("CVAR_UPDATE")
    size:SetScript("OnEvent", function(_, event)
        SetCVar ("NamePlateVerticalScale", db.height)    -- Set Nameplate Height
        SetCVar("NamePlateHorizontalScale", db.width)   -- Set Nameplate Width
    end)
end