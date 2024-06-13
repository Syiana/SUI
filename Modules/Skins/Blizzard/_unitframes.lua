local Module = SUI:NewModule("Skins.UnitFrames");

function Module:OnEnable()
    if (SUI:Color()) then
        local frameList = {
            PartyMemberFrame1Texture,
            PartyMemberFrame2Texture,
            PartyMemberFrame3Texture,
            PartyMemberFrame4Texture,
            Boss1TargetFrameTextureFrameTexture,
            Boss2TargetFrameTextureFrameTexture,
            Boss3TargetFrameTextureFrameTexture,
            Boss4TargetFrameTextureFrameTexture,
            Boss5TargetFrameTextureFrameTexture,
            PaladinPowerBarBG,
            PetFrameTexture,
            Boss1TargetFrameSpellBar.Border,
            Boss2TargetFrameSpellBar.Border,
            Boss3TargetFrameSpellBar.Border,
            Boss4TargetFrameSpellBar.Border,
            Boss5TargetFrameSpellBar.Border,
            PartyMemberFrame1PetFrameTexture,
            PartyMemberFrame2PetFrameTexture,
            PartyMemberFrame3PetFrameTexture,
            PartyMemberFrame4PetFrameTexture,
            PlayerFrameAlternateManaBarBorder,
            PlayerFrameTexture,
            FocusFrameTextureFrameTexture,
            TargetFrameTextureFrameTexture,
            TargetFrameToTTextureFrameTexture,
            FocusFrameToTTextureFrameTexture,
            PlayerFrameVehicleTexture
        }

        SUI:Skin(frameList, true, true)
    end
end
