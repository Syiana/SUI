local Module = SUI:NewModule("Maps.Minimap");

function Module:OnEnable()
  local db = SUI.db.profile.maps
	if (db) then
    if not (db.minimap) then MinimapCluster:Hide() return end
    if not (IsAddOnLoaded("SexyMap")) then
      if (SUI:Color()) then
        for i, v in pairs({
          MinimapBorder,
          MiniMapMailBorder,
          QueueStatusMinimapButtonBorder,
          select(1, TimeManagerClockButton:GetRegions())
        }) do
          v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
      end
      select(2, TimeManagerClockButton:GetRegions()):SetVertexColor(1, 1, 1)


      if (db.garrison) then
        hooksecurefunc("GarrisonLandingPageMinimapButton_UpdateIcon", function(self)
          local garrisonType = C_Garrison.GetLandingPageGarrisonType()
          -- Legion
          if (db.style == "Legion" or garrisonType == 3) then
            self:GetNormalTexture():SetTexture(nil)
            self:GetPushedTexture():SetTexture(nil)
            if not gb then
              gb = CreateFrame("Frame", nil, GarrisonLandingPageMinimapButton)
              gb:SetFrameLevel(GarrisonLandingPageMinimapButton:GetFrameLevel())
              gb:SetPoint("CENTER", 0, 0)
              gb:SetSize(36,36)
              gb.icon = gb:CreateTexture(nil, "ARTWORK")
              gb.icon:SetPoint("CENTER", 0, 0)
              gb.icon:SetSize(36,36)

              gb.border = CreateFrame("Frame", nil, gb)
              gb.border:SetFrameLevel(gb:GetFrameLevel() + 1)
              gb.border:SetAllPoints()
              gb.border.texture = gb.border:CreateTexture(nil, "ARTWORK")
              gb.border.texture:SetTexture("Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Ring")
              gb.border.texture:SetPoint("CENTER", 1, -2)
              gb.border.texture:SetSize(45,45)
            end
            if (garrisonType == 2) then
              if select(1,UnitFactionGroup("player")) == "Alliance" then
                SetPortraitToTexture(gb.icon, select(3,GetSpellInfo(61573)))
              elseif select(1,UnitFactionGroup("player")) == "Horde" then
                SetPortraitToTexture(gb.icon, select(3,GetSpellInfo(61574)))
              end
            else
              local t = CLASS_ICON_TCOORDS[select(2,UnitClass("player"))]
              gb.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
              gb.icon:SetTexCoord(unpack(t))
            end
          else
            --BFA
            if (garrisonType == LE_GARRISON_TYPE_8_0) then
              if select(1,UnitFactionGroup("player")) == "Horde" then
                if not gb then
                  gb = CreateFrame("Frame", nil, GarrisonLandingPageMinimapButton)
                  gb:SetFrameLevel(GarrisonLandingPageMinimapButton:GetFrameLevel() - 1)
                  gb:SetPoint("CENTER", -1, 2)
                  gb:SetSize(37,37)
                  gb.border = CreateFrame("Frame", nil, gb)
                  gb.border:SetFrameLevel(gb:GetFrameLevel() + 1)
                  gb.border:SetAllPoints()
                  gb.border.texture = gb.border:CreateTexture(nil, "OVERLAY")
                  gb.border.texture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\map\\OrderHallLandingButtonHordeborder")
                  gb.border.texture:SetTexCoord(0.40625, 0.757812, 0.421875, 0.820312)
                  gb.border.texture:SetPoint("CENTER", 1, -2)
                  gb.border.texture:SetSize(45,50)
                end
              else
                if not gb then
                  gb = CreateFrame("Frame", nil, GarrisonLandingPageMinimapButton)
                  gb:SetFrameLevel(GarrisonLandingPageMinimapButton:GetFrameLevel())
                  gb:SetPoint("CENTER", -1, 2)
                  gb:SetSize(37,37)
                  gb.border = CreateFrame("Frame", nil, gb)
                  gb.border:SetFrameLevel(gb:GetFrameLevel() + 1)
                  gb.border:SetAllPoints()
                  gb.border.texture = gb.border:CreateTexture(nil, "OVERLAY")
                  gb.border.texture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\map\\OrderHallLandingButtonAllianceborder")
                  gb.border.texture:SetTexCoord(0.382812, 0.742188, 0.0078125, 0.40625)
                  gb.border.texture:SetPoint("CENTER", 1, -2)
                  gb.border.texture:SetSize(45,50)
                end
              end
            end
          end
          if (gb and SUI:Color()) then
            gb.border.texture:SetVertexColor(unpack(SUI:Color(0.15)))
          end
        end)
      end

      MinimapZoneText:SetPoint("CENTER", Minimap, 0, 80)
      Minimap:EnableMouseWheel(true)
      Minimap:SetScript("OnMouseWheel", function(self, z)
        local c = Minimap:GetZoom()
        if (z > 0 and c < 5) then
          Minimap:SetZoom(c + 1)
        elseif (z < 0 and c > 0) then
          Minimap:SetZoom(c - 1)
        end
      end)

      Minimap:SetScript("OnMouseUp", function(self, btn)
        if btn == "RightButton" then
          _G.GameTimeFrame:Click()
        elseif btn == "MiddleButton" then
          _G.ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, self)
        else
          _G.Minimap_OnClick(self)
        end
      end)
    end
  end
end