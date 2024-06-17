local Module = SUI:NewModule("Skins.Dressup");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(DressUpFrame)
        SUI:Skin(DressUpFrameResetButton)
        SUI:Skin(DressUpFrameCancelButton)
    end
end
