local Module = SUI:NewModule("Skins.Frames");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(GameMenuFrame)
        SUI:Skin(GameMenuFrame.Header)
        SUI:Skin(GameMenuFrame.Border)
        SUI:Skin(StaticPopup1)
        SUI:Skin(StaticPopup1.Border)
        SUI:Skin(StaticPopup2)
        SUI:Skin(StaticPopup2.Border)
        SUI:Skin(StaticPopup3)
        SUI:Skin(StaticPopup3.Border)
        SUI:Skin(EditModeManagerFrame)
        SUI:Skin(EditModeManagerFrame.Border)
        SUI:Skin(VehicleSeatIndicator)
    end
end
