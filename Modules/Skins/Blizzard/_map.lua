local Module = SUI:NewModule("Skins.Map");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(WorldMapTitleButton)
        SUI:Skin(WorldMapFrame)
        SUI:Skin(WorldMapFrame.MiniBorderFrame)
    end
end
