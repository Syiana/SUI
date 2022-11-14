local Module = SUI:NewModule("CastBars.Target");

function Module:OnEnable()
  local db = SUI.db.profile.castbars

  local Size = CreateFrame("Frame")
  Size:RegisterEvent("ADDON_LOADED")
  Size:RegisterEvent("PLAYER_LOGIN")
  Size:RegisterEvent("PLAYER_ENTERING_WORLD")
  Size:RegisterEvent("VARIABLES_LOADED")
  Size:SetScript("OnEvent", function()
    TargetFrameSpellBar:SetScale(db.targetSize)
  end)

  if (db.targetOnTop) then
    local Reposition = CreateFrame("Frame")
    Reposition:RegisterEvent("UNIT_SPELLCAST_START")
    Reposition:RegisterEvent("UNIT_SPELLCAST_STOP")
    Reposition:RegisterEvent("UNIT_SPELLCAST_FAILED")
    Reposition:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    Reposition:RegisterEvent("UNIT_SPELLCAST_DELAYED")
    Reposition:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    Reposition:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
    Reposition:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
    Reposition:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
    Reposition:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
    Reposition:RegisterEvent("PLAYER_ENTERING_WORLD")
    Reposition:RegisterEvent("PLAYER_TARGET_CHANGED")
    Reposition:SetScript("OnEvent", function()
      TargetFrameSpellBar:ClearAllPoints()
      TargetFrameSpellBar:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 45, 0)
    end)
  end

  if (db.style == 'Custom' and db.targetCastbar) then
    if not InCombatLockdown() then
      TargetFrameSpellBar.Icon:SetSize(16, 16)
      TargetFrameSpellBar.Icon:ClearAllPoints()
      TargetFrameSpellBar.Icon:SetPoint("TOPLEFT", TargetFrameSpellBar, "TOPLEFT", -20, 2)
      TargetFrameSpellBar:SetSize(150, 12)
      TargetFrameSpellBar.TextBorder:ClearAllPoints()
      TargetFrameSpellBar.TextBorder:SetAlpha(0)
      TargetFrameSpellBar.Text:ClearAllPoints()
      TargetFrameSpellBar.Text:SetPoint("TOP", TargetFrameSpellBar, "TOP", 0, 1.5)
      TargetFrameSpellBar.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

      if not db.icon then
        TargetFrameSpellBar.Icon:Hide()
      end

      TargetFrameSpellBar:HookScript("OnEvent", function()
        local castText = TargetFrameSpellBar.Text:GetText()
        if castText ~= nil then
          if(strlen(castText) > 19) then
            local newCastText = strsub(castText, 0, 19)
            TargetFrameSpellBar.Text:SetText(newCastText.."...")
          end
        end
      end)
    end
  end
end