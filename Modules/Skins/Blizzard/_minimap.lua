local Module = SUI:NewModule("Skins.Minimap");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin({MinimapBorder}, true, true)
    end
end