local Module = SUI:NewModule("Skins.Petition");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(PetitionFrame)

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

        -- Buttons
        SUI:Skin({
            PetitionFrameRequestButton.Left,
            PetitionFrameRequestButton.Middle,
            PetitionFrameRequestButton.Right,
            PetitionFrameRenameButton.Left,
            PetitionFrameRenameButton.Middle,
            PetitionFrameRenameButton.Right,
            PetitionFrameSignButton.Left,
            PetitionFrameSignButton.Middle,
            PetitionFrameSignButton.Right,
            PetitionFrameCancelButton.Left,
            PetitionFrameCancelButton.Middle,
            PetitionFrameCancelButton.Right
        }, false, true, false, true)
    end
end
