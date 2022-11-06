local Module = SUI:NewModule("UnitFrames.Target");

function Module:OnEnable()

  local db = SUI.db.profile.unitframes

  function TestUpdate(self, auraList, numAuras, numOppositeAuras, setupFunc, anchorFunc, maxRowWidth, offsetX, mirrorAurasVertically)
    
      local hooked = {}
      local function UpdateTargetAuras(pool)
        for frame, _ in pairs(pool.activeObjects) do
          if not hooked[frame] then
              hooked[frame] = true

              local icon = frame.Icon
              icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
              icon:SetDrawLayer("BACKGROUND",-8)
              frame.icon = icon

              if not frame.border then
                local border = frame.border or 
                frame:CreateTexture(frame.border, "BACKGROUND", nil, -7)

                border:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss")
                border:SetTexCoord(0, 1, 0, 1)
                border:SetDrawLayer("BACKGROUND",- 7)
                border:ClearAllPoints()
                border:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
                border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
                frame.border = border

                local backdrop = {
                  bgFile = nil,
                  edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
                  tile = false,
                  tileSize = 32,
                  edgeSize = 4,
                  insets = {
                    left = 4,
                    right = 4,
                    top = 4,
                    bottom = 4,
                  },
                }
                local back = CreateFrame("Frame", nil, frame, "BackdropTemplate")
                back:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, 4)
                back:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -4)
                back:SetFrameLevel(frame:GetFrameLevel() - 1)
                back:SetBackdrop(backdrop)
                back:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))
                frame.bg = back
              end
          end
        end
      end
    
      for poolKey, pool in pairs(TargetFrame.auraPools.pools) do
          hooksecurefunc(pool, "Acquire", UpdateTargetAuras)
      end

      for poolKey, pool in pairs(FocusFrame.auraPools.pools) do
        hooksecurefunc(pool, "Acquire", UpdateTargetAuras)
      end

  end

  local hooked = {}
  local function UpdateFrameAuras(pool)
    for frame, _ in pairs(pool.activeObjects) do
      if not hooked[frame] then
          hooked[frame] = true

          local icon = frame.Icon
          icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
          icon:SetDrawLayer("BACKGROUND",-8)
          frame.Icon = icon

          if not frame.border then
            local border = frame.border or 
            frame:CreateTexture(frame.border, "BACKGROUND", nil, -7)

            border:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss")
            border:SetTexCoord(0, 1, 0, 1)
            border:SetDrawLayer("BACKGROUND",- 7)
            border:ClearAllPoints()
            border:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
            border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
            frame.border = border

            local backdrop = {
              bgFile = nil,
              edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
              tile = false,
              tileSize = 32,
              edgeSize = 4,
              insets = {
                left = 4,
                right = 4,
                top = 4,
                bottom = 4,
              },
            }
            local back = CreateFrame("Frame", nil, frame, "BackdropTemplate")
            back:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, 4)
            back:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -4)
            back:SetFrameLevel(frame:GetFrameLevel() - 1)
            back:SetBackdrop(backdrop)
            back:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))
            frame.bg = back
          end
      end
    end
  end

  for poolKey, pool in pairs(TargetFrame.auraPools.pools) do
    hooksecurefunc(pool, "Acquire", UpdateFrameAuras)
  end

  for poolKey, pool in pairs(FocusFrame.auraPools.pools) do
    hooksecurefunc(pool, "Acquire", UpdateFrameAuras)
  end

  local function SUIColorRepBar(self)
    local reputationBar = self.TargetFrameContent.TargetFrameContentMain.ReputationColor
    reputationBar:SetVertexColor(unpack(SUI:Color(0.15)))  
  end

  -- On Update Target Frame
  hooksecurefunc(TargetFrame, "Update", SUIColorRepBar)

  -- On Update Focus Frame
  hooksecurefunc(FocusFrame, "Update", SUIColorRepBar)

  -- Set TargetFrame Buff/Debuff SetSize
  hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(_, buff)
    buff:SetSize(db.buffs.size, db.buffs.size)

    if buff.Count then
      local fontSize = db.debuffs.size / 2.75
      buff.Count:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
      buff.Count:ClearAllPoints()
      buff.Count:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", 0, 0)
    end
  end)

  hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(_, debuff)
    debuff:SetSize(db.debuffs.size, db.debuffs.size)

    if debuff.Count then
      local fontSize = db.debuffs.size / 2.75
      debuff.Count:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
      debuff.Count:ClearAllPoints()
      debuff.Count:SetPoint("BOTTOMRIGHT", debuff, "BOTTOMRIGHT", 0, 0)
    end
  end)
end