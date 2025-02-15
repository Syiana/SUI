local Module = SUI:NewModule("Skins.Dungeon");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(GameMenuFrame)
        SUI:Skin(GameMenuFrame.Border)
        SUI:Skin(StaticPopup1)
        SUI:Skin(StaticPopup1.Border)
        SUI:Skin(StaticPopup2)
        SUI:Skin(StaticPopup2.Border)
        SUI:Skin(StaticPopup3)
        SUI:Skin(StaticPopup3.Border)
    end
end
