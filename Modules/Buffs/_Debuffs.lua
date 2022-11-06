local Debuffs = SUI:NewModule("Buffs.Debuffs")

function Debuffs:OnEnable()
    local hooked = {}

    -- DebuffType Colors for the Debuff Border
    debuffColor = {}
    debuffColor["none"]    = { r = 0.80, g = 0, b = 0 };
    debuffColor["Magic"]   = { r = 0.20, g = 0.60, b = 1.00 };
    debuffColor["Curse"]   = { r = 0.60, g = 0.00, b = 1.00 };
    debuffColor["Disease"] = { r = 0.60, g = 0.40, b = 0 };
    debuffColor["Poison"]  = { r = 0.00, g = 0.60, b = 0 };

    function UpdateDebuffStyling(pool)
        for frame, _ in pairs(pool.activeObjects) do
            if not hooked[frame] then
                hooked[frame] = true

                local icon = frame.Icon
                icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
                if frame.Border then frame.Border:Hide() end
                frame.duration:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")

                if DebuffFrame.exampleAuraFrames == nil then
                    hooksecurefunc(frame, "UpdateDuration", function(self)
                        
                        local durationText = self.duration:GetText()
                        if durationText ~= nil then
                            if strfind(durationText, " ") then
                                self.duration:SetText(gsub(durationText, " ", ""))
                            end
                        end

                        local count = self.count
                        if count ~= nil then
                            count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                            count:ClearAllPoints()
                            count:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -2)
                        end

                        self.duration:ClearAllPoints()
                        self.duration:SetPoint("CENTER", frame, "BOTTOM", 0, 15)
                        self.duration:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
                    end)
                end
                
                ButtonBackdrop(frame)
            end
        end
    end
    
    for _, pool in pairs(DebuffFrame.auraPool.pools) do
        hooksecurefunc(pool, "Acquire", UpdateDebuffStyling)
    end

    EditModeManagerFrame:HookScript("OnShow", function()
        hooksecurefunc(DebuffFrame, "UpdateAuraButtons", function() end)
    end)

    function ButtonDefault(button)
        local Backdrop = {
            bgFile = "",
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 5,
            insets = { left = 5, right = 5, top = 5, bottom = 5 }
        }
        local icon = button.Icon

        local border = CreateFrame("Frame", nil, button)
        border:SetSize(icon:GetWidth() + 5, icon:GetHeight() + 6)
        border:SetPoint("CENTER", button, "CENTER", 1, 5)

        border.texture = border:CreateTexture(nil, "Border")
        border.texture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\UIActionBar")
        border.texture:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
        border.texture:SetVertexColor(0, 0, 0)
        border.texture:SetAllPoints()

        local shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
        shadow:SetSize(icon:GetWidth(), icon:GetHeight())
        shadow:SetPoint("TOPLEFT", border, "TOPLEFT", -2, 2)
        shadow:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 1, -1)
        shadow:SetFrameLevel(button:GetFrameLevel() - 1)
        shadow:SetBackdrop(Backdrop)
        shadow:SetBackdropBorderColor(0, 0, 0)
    end

    function ButtonBackdrop(button)
        local Backdrop = {
            bgFile = "",
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 5,
            insets = { left = 5, right = 5, top = 5, bottom = 5 }
        }

        local icon = button.Icon
        local point, relativeTo, relativePoint, xOfs, yOfs = icon:GetPoint()

        local border = CreateFrame("Frame", nil, button)
        border:SetSize(icon:GetWidth(), icon:GetHeight())
        border:SetPoint("CENTER", button, "CENTER", 0, 0)

        border.texture = border:CreateTexture(nil, "Border")
        border.texture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\Normal_N")
        border.texture:SetVertexColor(0, 0, 0)
        border.texture:SetSize(40, 40)
        border.texture:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs + 5)
    end

    function ButtonBorder(Button)

    end
end


--[[local Debuffs = SUI:NewModule("Buffs.Debuffs");

function Debuffs:OnEnable()
  if IsAddOnLoaded("BlizzBuffsFacade") then return end

  -- DebuffType Colors for the Debuff Border
  DebuffTypeColor = {}
  DebuffTypeColor["none"]    = { r = 0.80, g = 0, b = 0 };
  DebuffTypeColor["Magic"]    = { r = 0.20, g = 0.60, b = 1.00 };
  DebuffTypeColor["Curse"]    = { r = 0.60, g = 0.00, b = 1.00 };
  DebuffTypeColor["Disease"]    = { r = 0.60, g = 0.40, b = 0 };
  DebuffTypeColor["Poison"]    = { r = 0.00, g = 0.60, b = 0 };

  function updateDebuffs()
    local AuraNum = DebuffFrame.AuraContainer:GetNumChildren()
    local Children = { DebuffFrame.AuraContainer:GetChildren() }

    for _, child in pairs(Children) do
      local icon =  child.Icon
      local t = select(_, DebuffFrame.AuraContainer:GetChildren())
      local dur = t.duration
      local count = t.count
      local point, relativeTo, relativePoint, xOfs, yOfs = icon:GetPoint()
      child.Border:Hide()

      icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
      icon:SetSize(32, 32)

      HOUR_ONELETTER_ABBR = "%dh"
      DAY_ONELETTER_ABBR = "%dd"
      MINUTE_ONELETTER_ABBR = "%dm"
      SECOND_ONELETTER_ABBR = "%ds"
    
      if not icon.border then
        local border = CreateFrame("Frame", "SUIBuffBorder", t, "BackdropTemplate")
        border:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs + 5)
        border:SetSize(42, 42)
        border:SetFrameLevel(3)
    
        local backdrop = {
          edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
          edgeSize = 6,
          insets = { left = 6, right = 6, top = 6, bottom = 6 },
        }

        border:SetBackdrop(backdrop)
        border:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))
        icon.border = border

        local texture = icon.border:CreateTexture()
        texture:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Core\\Normal_N")
        texture:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs + 5)
        texture:SetSize(42, 42)
        texture:SetVertexColor(0, 0, 0)
        icon.border.texture = texture
        border:Show()
      end

      if (count) then
        -- Set Stack Font size and reposition it
        count:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
        count:ClearAllPoints()
        count:SetPoint("TOPRIGHT", t, "TOPRIGHT", 0, -2)
      end

      -- Set Duration FOnt size and reposition it
      dur:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
      dur:ClearAllPoints()
      dur:SetPoint("CENTER", t, "BOTTOM", 0, 13)
      dur:SetDrawLayer("OVERLAY")

      -- Set the color of the Debuff Border
      local debuffType
      if (child.buttonInfo) then
        debuffType = child.buttonInfo.debuffType
      end
      if (icon.border) then
        local color
        if (debuffType) then
          color = DebuffTypeColor[debuffType]
        else
          color = DebuffTypeColor["none"]
        end
        icon.border.texture:SetVertexColor(color.r, color.g, color.b, 0.8)
      end
    end
  end

  local frame = CreateFrame("Frame")
  frame:RegisterEvent("PLAYER_ENTERING_WORLD", self, "Update")
  frame:RegisterUnitEvent("UNIT_AURA", self, "Update")
  frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  frame:SetScript("OnEvent", function(self, event, ...)
    updateDebuffs()
  end)
end]]