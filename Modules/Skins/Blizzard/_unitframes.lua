local Module = SUI:NewModule("Skins.UnitFrames");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in ipairs({
      PlayerFrameTexture,
      TargetFrameTextureFrameTexture,
      PlayerFrameAlternateManaBarBorder,
      PlayerFrameAlternateManaBarLeftBorder,
      PlayerFrameAlternateManaBarRightBorder,
      PaladinPowerBarFrameBG,
      PaladinPowerBarFrameBankBG,
      ComboPointPlayerFrameBackground,
      ComboPointPlayerFrameCombo1PointOff,
      ComboPointPlayerFrameCombo2PointOff,
      ComboPointPlayerFrameCombo3PointOff,
      ComboPointPlayerFrameCombo4PointOff,
      ComboPointPlayerFrameCombo5PointOff,
      ComboPointPlayerFrameCombo6PointOff,
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
      Boss1TargetFrameSpellBarBorder,
      Boss2TargetFrameSpellBarBorder,
      Boss3TargetFrameSpellBarBorder,
      Boss4TargetFrameSpellBarBorder,
      Boss5TargetFrameSpellBarBorder,
      CastingBarFrame.Border,
      FocusFrameSpellBarBorder,
      TargetFrameSpellBarBorder,
      StatusTrackingBarManagerSingleBarLargeUpper,
      StatusTrackingBarManagerSingleBarSmallUpper,
    }) do
      v:SetVertexColor(unpack(SUI:Color(0.15)))
    end

    -- SUI:SetScript("OnEvent", function(self, event)
    --   ColorRaid()
    --   PlayerFrameGroupIndicator:SetAlpha(0)
    --   PlayerHitIndicator:SetText(nil)
    --   PlayerHitIndicator.SetText = function()
    --   end
    --   PetHitIndicator:SetText(nil)
    --   PetHitIndicator.SetText = function()
    --   end
    --   for _, child in pairs({WarlockPowerFrame:GetChildren()}) do
    --     for _, region in pairs({child:GetRegions()}) do
    --       if region:GetDrawLayer() == "BORDER" then
    --         region:SetVertexColor(unpack(color.secondary))
    --       end
    --     end
    --   end

    -- end)
  end
end