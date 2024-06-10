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
      -- ComboPointPlayerFrame.Background,
      -- ComboPointPlayerFrame.Combo1.PointOff,
      -- ComboPointPlayerFrame.Combo2.PointOff,
      -- ComboPointPlayerFrame.Combo3.PointOff,
      -- ComboPointPlayerFrame.Combo4.PointOff,
      -- ComboPointPlayerFrame.Combo5.PointOff,
      -- ComboPointPlayerFrame.Combo6.PointOff,
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
      -- StatusTrackingBarManager.SingleBarLargeUpper,
      -- StatusTrackingBarManager.SingleBarSmallUpper,
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