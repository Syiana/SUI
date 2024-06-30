local Module = SUI:NewModule("Skins.Map");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(WorldMapTitleButton)
        SUI:Skin(WorldMapFrame)
        SUI:Skin(WorldMapFrame.MiniBorderFrame)
        SUI:Skin(WorldMapFrame.BorderFrame)
        SUI:Skin(WorldMapFrame.BlackoutFrame)
        SUI:Skin(WorldMapZoneMinimapDropDown)
        SUI:Skin(WorldMapContinentDropDown)
        SUI:Skin(WorldMapZoneDropDown)

        -- Buttons
        SUI:Skin({
            WorldMapZoomOutButton.Left,
            WorldMapZoomOutButton.Middle,
            WorldMapZoomOutButton.Right
        }, false, true, false, true)
    end
end
