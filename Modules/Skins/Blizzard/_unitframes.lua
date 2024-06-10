local Module = SUI:NewModule("Skins.UnitFrames");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in ipairs({
      PaladinPowerBarBG,
      PlayerFrameTexture,
      TargetFrameTextureFrameTexture,
      PlayerFrameAlternateManaBarBorder,
      PlayerFrameAlternateManaBarLeftBorder,
      PlayerFrameAlternateManaBarRightBorder,
      PetFrameTexture,
      PartyMemberFrame1Texture,
      PartyMemberFrame2Texture,
      PartyMemberFrame3Texture,
      PartyMemberFrame4Texture,
      PartyMemberFrame1PetFrameTexture,
      PartyMemberFrame2PetFrameTexture,
      PartyMemberFrame3PetFrameTexture,
      PartyMemberFrame4PetFrameTexture,
      FocusFrameTextureFrameTexture,
      TargetFrameToTTextureFrameTexture,
      FocusFrameToTTextureFrameTexture,
      Boss1TargetFrameTextureFrameTexture,
      Boss2TargetFrameTextureFrameTexture,
      Boss3TargetFrameTextureFrameTexture,
      Boss4TargetFrameTextureFrameTexture,
      Boss5TargetFrameTextureFrameTexture,
      Boss1TargetFrameSpellBar.Border,
      Boss2TargetFrameSpellBar.Border,
      Boss3TargetFrameSpellBar.Border,
      Boss4TargetFrameSpellBar.Border,
      Boss5TargetFrameSpellBar.Border,
    }) do
      v:SetVertexColor(unpack(SUI:Color(0.15)))
    end
  end
end