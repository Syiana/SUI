local Module = SUI:NewModule("Skins.UnitFrames");

function Module:OnEnable()
    if (SUI:Color()) then
			for i, v in ipairs({
				PlayerFrameTexture,
				TargetFrameTextureFrameTexture,
				TargetFrameToTTextureFrameTexture,
				PetFrameTexture,
				PartyMemberFrame1Texture,
				PartyMemberFrame2Texture,
				PartyMemberFrame3Texture,
				PartyMemberFrame4Texture,
				PartyMemberFrame1PetFrameTexture,
				PartyMemberFrame2PetFrameTexture,
				PartyMemberFrame3PetFrameTexture,
				PartyMemberFrame4PetFrameTexture,
				CastingBarFrame.Border,
				TargetFrameSpellBar.Border
			}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
    end
end