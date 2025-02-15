local Module = SUI:NewModule("Skins.Petition");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(PetitionFrame)
        SUI:Skin(PetitionFrame.NineSlice)
        SUI:Skin(PetitionFrameInset)
    end
end
