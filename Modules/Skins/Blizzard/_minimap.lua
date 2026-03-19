local Module = SUI:NewModule("Skins.Minimap");

function Module:OnEnable()
    if (SUI:Color()) then
        local compass = MinimapCompassTexture
        compass:SetDesaturated(true)
        MinimapCompassTexture:SetVertexColor(unpack(SUI:Color(0.2)))
    end
end
