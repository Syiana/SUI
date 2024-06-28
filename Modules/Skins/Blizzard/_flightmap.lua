local Module = SUI:NewModule("Skins.FlightMap");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(TaxiFrame)
    end
end
