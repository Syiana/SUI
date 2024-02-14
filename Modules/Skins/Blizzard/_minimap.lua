local Module = SUI:NewModule("Skins.Minimap");

function Module:OnEnable()
    if (SUI:Color()) then
        local compass = MinimapCompassTexture
        compass:SetDesaturated(true)
        compass:SetVertexColor(unpack(SUI:Color(0.15)))
    end
end
