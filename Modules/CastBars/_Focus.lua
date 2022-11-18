local Module = SUI:NewModule("CastBars.Focus");

function Module:OnEnable()
  local db = SUI.db.profile.castbars
  
  local Size = CreateFrame("Frame")
  Size:RegisterEvent("ADDON_LOADED")
  Size:RegisterEvent("PLAYER_LOGIN")
  Size:RegisterEvent("PLAYER_ENTERING_WORLD")
  Size:RegisterEvent("VARIABLES_LOADED")
  Size:SetScript("OnEvent", function()
    FocusFrameSpellBar:SetScale(db.focusSize)
  end)

  if (db.focusOnTop) then

    FocusFrameSpellBar:HookScript("OnUpdate", function()
      FocusFrameSpellBar:ClearAllPoints()
      FocusFrameSpellBar:SetPoint("TOPLEFT", FocusFrame, "TOPLEFT", 45, 0)
    end)
  end

  if (db.style == 'Custom' and db.focusCastbar) then
    if not InCombatLockdown() then
      FocusFrameSpellBar.Icon:SetSize(16, 16)
      FocusFrameSpellBar.Icon:ClearAllPoints()
      FocusFrameSpellBar.Icon:SetPoint("TOPLEFT", FocusFrameSpellBar, "TOPLEFT", -20, 2)
      FocusFrameSpellBar.BorderShield:ClearAllPoints()
      FocusFrameSpellBar.BorderShield:SetPoint("CENTER", FocusFrameSpellBar.Icon, "CENTER", 0, -2.5)
      FocusFrameSpellBar:SetSize(150, 12)
      FocusFrameSpellBar.TextBorder:ClearAllPoints()
      FocusFrameSpellBar.TextBorder:SetAlpha(0)
      FocusFrameSpellBar.Text:ClearAllPoints()
      FocusFrameSpellBar.Text:SetPoint("TOP", FocusFrameSpellBar, "TOP", 0, 1.5)
      FocusFrameSpellBar.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

      if not db.icon then
        FocusFrameSpellBar.Icon:Hide()
      end

      FocusFrameSpellBar:HookScript("OnEvent", function()
        local castText = FocusFrameSpellBar.Text:GetText()
        if castText ~= nil then
          if(strlen(castText) > 19) then
            local newCastText = strsub(castText, 0, 19)
            FocusFrameSpellBar.Text:SetText(newCastText.."...")
          end
        end
      end)
    end
  end
end