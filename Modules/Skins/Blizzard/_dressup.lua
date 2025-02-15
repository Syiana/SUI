local Module = SUI:NewModule("Skins.Dressup")

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(DressUpFrame)
        SUI:Skin(DressUpFrame.NineSlice)
        SUI:Skin(DressUpFrame.OutfitDetailsPanel)
        SUI:Skin(DressUpFrameInset)
        SUI:Skin(DressUpFrameInset.NineSlice)
    end
end
