local Module = SUI:NewModule("Maps.Hide");

function Module:OnEnable()
    local db = {
        date = SUI.db.profile.maps.date,
        tracking = SUI.db.profile.maps.tracking,
        clock = SUI.db.profile.maps.clock,
        module = SUI.db.profile.modules.map
    }

    if (db.module) then
        if not (db.date) then
            GameTimeFrame:Hide()
            GameTimeFrame:UnregisterAllEvents()
            GameTimeFrame.Show = kill
        end

        if not (db.tracking) then
            MiniMapTracking:Hide()
            MiniMapTracking.Show = kill
            MiniMapTracking:UnregisterAllEvents()
        end

        if not (db.clock) then
            TimeManagerClockButton:Hide()
        end

        Minimap:HookScript("OnEvent", function()
            MiniMapWorldMapButton:Hide()
        end)

        MinimapBorderTop:Hide()
        MinimapZoomIn:Hide()
        MinimapZoomOut:Hide()
    end
end
