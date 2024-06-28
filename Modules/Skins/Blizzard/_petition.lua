local Module = SUI:NewModule("Skins.Petition");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(PetitionFrame)
        SUI:Skin(PetitionFrameRequestButton)
        SUI:Skin(PetitionFrameRenameButton)
        SUI:Skin(PetitionFrameCancelButton)

        local texts = {
            PetitionFrameCharterTitle,
            PetitionFrameCharterName,
            PetitionFrameMasterTitle,
            PetitionFrameMasterName,
            PetitionFrameMemberTitle,
            PetitionFrameMemberName1,
            PetitionFrameMemberName2,
            PetitionFrameMemberName3,
            PetitionFrameMemberName4,
            PetitionFrameInstructions
        }

        for _, v in pairs(texts) do
            v:SetTextColor(.8, .8, .8)
        end
    end
end
