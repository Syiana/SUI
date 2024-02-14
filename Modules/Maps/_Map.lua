local Module = SUI:NewModule("Maps.Map")

function Module:OnEnable()
    local db = SUI.db.profile.maps

    if db then
        local Size = CreateFrame("Frame")
        Size:RegisterEvent("ADDON_LOADED")
        Size:RegisterEvent("PLAYER_LOGIN")
        Size:RegisterEvent("PLAYER_ENTERING_WORLD")
        Size:RegisterEvent("VARIABLES_LOADED")
        Size:SetScript("OnEvent", function()
            WorldMapFrame:SetAlpha(db.opacity)
        end)
    end
end
