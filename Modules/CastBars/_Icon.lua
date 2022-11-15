local Module = SUI:NewModule("CastBars.Icon");

function Module:OnEnable()
  local db = SUI.db.profile.castbars
  if (db.style == 'Custom' and SUI:Color() and db.icon) then
      if not InCombatLockdown() then
        local function IconSkin(b)
            if not b or (b and b.styled) then return end

            b:SetTexCoord(0.1, 0.9, 0.1, 0.9)

            if b == PlayerCastingBarFrame.Icon and (PlayerCastingBarFrame) then
                b.parent = PlayerCastingBarFrame
            elseif b == FocusFrameSpellBar.Icon then
                b.parent = FocusFrameSpellBar
            else
                b.parent = TargetFrameSpellBar
            end

            local Backdrop = {
              bgFile = nil,
              edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
              tile = false,
              tileSize = 32,
              edgeSize = 6,
              insets = { left = 6, right = 6, top = 6, bottom = 6 },
            }

            local border = CreateFrame("Frame", nil, b.parent)
            border:SetSize(b:GetWidth() + 4, b:GetHeight() + 4)
            border:SetPoint("CENTER", b, "CENTER", 0, 0)
            
            border.texture = border:CreateTexture()
            border.texture:SetAllPoints()
            border.texture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss_border")
            border.texture:SetTexCoord(0,1,0,1)
            border.texture:SetDrawLayer("BACKGROUND",-7)
            border.texture:SetVertexColor(0.4, 0.35, 0.35)

            border.shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
            border.shadow:SetPoint("TOPLEFT", border, "TOPLEFT", -4, 4)
            border.shadow:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 4, -4)
            border.shadow:SetBackdrop(Backdrop)
            border.shadow:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))

            b.SUIBorder = border
            b.styled = true
          end

          local total = 0
          local timer = CreateFrame("Frame")
          timer:SetScript("OnUpdate", function(self, elapsed)
            total = total + elapsed
            if PlayerCastingBarFrame.Icon then
              IconSkin(PlayerCastingBarFrame.Icon)
            end
            if TargetFrameSpellBar.Icon then
              IconSkin(TargetFrameSpellBar.Icon)
            end
            if FocusFrameSpellBar.Icon then
              IconSkin(FocusFrameSpellBar.Icon)
            end
            if PlayerCastingBarFrame.Icon.styled and TargetFrameSpellBar.Icon.styled then
              timer:SetScript("OnUpdate", nil)
            end
          end)
      end
    end
end