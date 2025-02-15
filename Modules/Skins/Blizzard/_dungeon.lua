local Module = SUI:NewModule("Skins.Dungeon");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(GameMenuFrame, true)
        SUI:Skin(GameMenuFrame.Border, true)
        SUI:Skin(StaticPopup1, true)
        SUI:Skin(StaticPopup1.Border, true)
        SUI:Skin(StaticPopup2, true)
        SUI:Skin(StaticPopup2.Border, true)
        SUI:Skin(StaticPopup3, true)
        SUI:Skin(StaticPopup3.Border, true)
    end
end
