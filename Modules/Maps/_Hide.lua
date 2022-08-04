local Module = SUI:NewModule("Maps.Hide");

function Module:OnEnable()
  local db = SUI.db.profile.maps
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
  MiniMapWorldMapButton:SetAlpha(0)
  MiniMapWorldMapButton:EnableMouse(false)
  MinimapBorderTop:Hide()
  MinimapZoomIn:Hide()
  MinimapZoomOut:Hide()
end