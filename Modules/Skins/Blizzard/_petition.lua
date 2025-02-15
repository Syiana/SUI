local Module = SUI:NewModule("Skins.Petition");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(PetitionFrame, true)
        SUI:Skin(PetitionFrame.NineSlice, true)
        SUI:Skin(PetitionFrameInset, true)
    end
end
