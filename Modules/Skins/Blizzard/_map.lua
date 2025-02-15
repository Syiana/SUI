local Module = SUI:NewModule("Skins.Map");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(WorldMapFrame)
        SUI:Skin(WorldMapFrame.BorderFrame)
        SUI:Skin(WorldMapFrame.BorderFrame.NineSlice)
        SUI:Skin(WorldMapFrame.NavBar)
        SUI:Skin(WorldMapFrame.NavBar.overlay)
    end
end
