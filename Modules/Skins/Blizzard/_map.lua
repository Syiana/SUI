local Module = SUI:NewModule("Skins.Map");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(WorldMapFrame, true)
        SUI:Skin(WorldMapFrame.BorderFrame, true)
        SUI:Skin(WorldMapFrame.BorderFrame.NineSlice, true)
        SUI:Skin(WorldMapFrame.NavBar, true)
        SUI:Skin(WorldMapFrame.NavBar.overlay, true)
    end
end
