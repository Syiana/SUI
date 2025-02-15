local Module = SUI:NewModule("Skins.Dressup")

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(DressUpFrame, true)
        SUI:Skin(DressUpFrame.NineSlice, true)
        SUI:Skin(DressUpFrame.OutfitDetailsPanel, true)
        SUI:Skin(DressUpFrameInset, true)
        SUI:Skin(DressUpFrameInset.NineSlice, true)
    end
end
