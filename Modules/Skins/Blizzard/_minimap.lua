local Module = SUI:NewModule("Skins.Minimap");

function Module:OnEnable()
    local compass = MinimapCompassTexture
    compass:SetVertexColor(unpack(SUI:Color(0.15)))

    if (SUI:Color()) then
    end
end