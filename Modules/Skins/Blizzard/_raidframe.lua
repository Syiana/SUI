local Module = SUI:NewModule("Skins.RaidFrame");

function Module:OnEnable()
  if (SUI:Color()) then
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:SetScript("OnEvent", function(self, event)
      for g = 1, NUM_RAID_GROUPS do
        local group = _G["CompactRaidGroup" .. g .. "BorderFrame"]
        if group then
          for _, region in pairs({group:GetRegions()}) do
            if region:IsObjectType("Texture") then
              region:SetVertexColor(unpack(SUI:Color(0.15)))
            end
          end
        end
        for m = 1, 5 do
          local frame = _G["CompactRaidGroup" .. g .. "Member" .. m]
          if frame then
            groupcolored = true
            for _, region in pairs({frame:GetRegions()}) do
              if region:GetName():find("Border") then
                region:SetVertexColor(unpack(SUI:Color(0.15)))
              end
            end
          end
          local frame = _G["CompactRaidFrame" .. m]
          if frame then
            singlecolored = true
            for _, region in pairs({frame:GetRegions()}) do
              if region:GetName():find("Border") then
                region:SetVertexColor(unpack(SUI:Color(0.15)))
              end
            end
          end
        end
      end
      for _, region in pairs({CompactRaidFrameContainerBorderFrame:GetRegions()}) do
        if region:IsObjectType("Texture") then
          region:SetVertexColor(unpack(SUI:Color(0.15)))
        end
      end
    end)

    for _, region in pairs({CompactRaidFrameManager:GetRegions()}) do
      if region:IsObjectType("Texture") then
        region:SetVertexColor(unpack(SUI:Color(0.15)))
      end
    end
    for _, region in pairs({CompactRaidFrameManagerContainerResizeFrame:GetRegions()}) do
      if region:GetName():find("Border") then
        region:SetVertexColor(unpack(SUI:Color(0.15)))
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
end