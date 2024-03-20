local Module = SUI:NewModule("Maps.Hide");

function Module:OnEnable()
    local db = SUI.db.profile.maps
    if not (IsAddOnLoaded("SexyMap")) then
        if not db.date then
            GameTimeFrame:UnregisterAllEvents()
            GameTimeFrame:Hide()
        end
        if not db.tracking then
            MinimapCluster.TrackingFrame.Button:UnregisterAllEvents()
            MinimapCluster.TrackingFrame.Button:Hide()
            MinimapCluster.TrackingFrame.Background:Hide()
        end
        if not db.clock then
            TimeManagerClockButton:Hide()
            TimeManagerClockTicker:Hide()
        end

        local Hide = CreateFrame("Frame")
        Hide:RegisterEvent("ADDON_LOADED")
        Hide:RegisterEvent("PLAYER_LOGIN")
        Hide:RegisterEvent("PLAYER_ENTERING_WORLD")
        Hide:RegisterEvent("VARIABLES_LOADED")
        Hide:SetScript("OnEvent", function()
            MinimapCluster.BorderTop:Hide(0)
        end)
    end
end
