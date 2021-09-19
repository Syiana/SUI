local Module = SUI:NewModule("Skins.RaidFrame");

function Module:OnEnable()
  local SUI = CreateFrame("Frame")
  SUI:RegisterEvent("PLAYER_ENTERING_WORLD")
  SUI:RegisterEvent("GROUP_ROSTER_UPDATE")

  function ColorRaid()
    for g = 1, NUM_RAID_GROUPS do
      local group = _G["CompactRaidGroup" .. g .. "BorderFrame"]
      if group then
        for _, region in pairs({group:GetRegions()}) do
          if region:IsObjectType("Texture") then
            region:SetVertexColor(unpack(color.secondary))
          end
        end
      end
      for m = 1, 5 do
        local frame = _G["CompactRaidGroup" .. g .. "Member" .. m]
        if frame then
          groupcolored = true
          for _, region in pairs({frame:GetRegions()}) do
            if region:GetName():find("Border") then
              region:SetVertexColor(unpack(color.secondary))
            end
          end
        end
        local frame = _G["CompactRaidFrame" .. m]
        if frame then
          singlecolored = true
          for _, region in pairs({frame:GetRegions()}) do
            if region:GetName():find("Border") then
              region:SetVertexColor(unpack(color.secondary))
            end
          end
        end
      end
    end
    for _, region in pairs({CompactRaidFrameContainerBorderFrame:GetRegions()}) do
      if region:IsObjectType("Texture") then
        region:SetVertexColor(unpack(color.secondary))
      end
    end
  end

  SUI:SetScript("OnEvent", function(self, event)
    ColorRaid()
    PlayerFrameGroupIndicator:SetAlpha(0)
    PlayerHitIndicator:SetText(nil)
    PlayerHitIndicator.SetText = function()
    end
    PetHitIndicator:SetText(nil)
    PetHitIndicator.SetText = function()
    end
    for _, child in pairs({WarlockPowerFrame:GetChildren()}) do
      for _, region in pairs({child:GetRegions()}) do
        if region:GetDrawLayer() == "BORDER" then
          region:SetVertexColor(unpack(color.secondary))
        end
      end
    end

  end)

  for _, region in pairs({CompactRaidFrameManager:GetRegions()}) do
    if region:IsObjectType("Texture") then
      region:SetVertexColor(unpack(color.secondary))
    end
  end
  for _, region in pairs({CompactRaidFrameManagerContainerResizeFrame:GetRegions()}) do
    if region:GetName():find("Border") then
      region:SetVertexColor(unpack(color.secondary))
    end
  end
  CompactRaidFrameManagerToggleButton:SetNormalTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidPanel-Toggle")
  for i = 1, 4 do
    _G["PartyMemberFrame" .. i .. "PVPIcon"]:SetAlpha(0)
    _G["PartyMemberFrame" .. i .. "NotPresentIcon"]:Hide()
    _G["PartyMemberFrame" .. i .. "NotPresentIcon"].Show = function()
    end
  end
end