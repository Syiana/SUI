local Module = SUI:NewModule("UnitFrames.Player");

function Module:OnEnable()
  local db = {
    unitframes = SUI.db.profile.unitframes,
    texture = SUI.db.profile.general.texture
  }

  --local playerFrameContainer = PlayerFrame.PlayerFrameContainer

  --playerFrameContainer.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))

  --playerFrameContainer.FrameTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UIUnitFrame")
  --playerFrameContainer.FrameTexture:SetTexCoord(0.001953125, 0.388671875, 0.001953125, 0.140625)
  --playerFrameContainer.FrameTexture:SetTexCoord(0.7890625, 0.982421875, 0.001953125, 0.140625)


  local statusTexture = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture;

  

  hooksecurefunc("PlayerFrame_UpdateStatus", function(self)
    if (IsResting()) then
      statusTexture:Hide()
    end
    --print('update amk')
    --statusTexture:Hide()
  end)

  -- 198 71

  --PlayerFrameManaBar.texture:SetVertexColor(0,0,0,1)

end