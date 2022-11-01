local Module = SUI:NewModule("CastBars.Focus");

function Module:OnEnable()
  local db = SUI.db.profile.castbars
    if (db.style == 'Custom' and db.focusCastbar) then
        if not InCombatLockdown() then
          FocusFrameSpellBar.Icon:Show()
          FocusFrameSpellBar.Icon:SetSize(16, 16)
          FocusFrameSpellBar.Icon:ClearAllPoints()
          FocusFrameSpellBar.Icon:SetPoint("TOPLEFT", FocusFrameSpellBar, "TOPLEFT", -20, 2)
          FocusFrameSpellBar:SetSize(150, 12)
          FocusFrameSpellBar.TextBorder:ClearAllPoints()
          FocusFrameSpellBar.TextBorder:SetAlpha(0)
          FocusFrameSpellBar.Text:ClearAllPoints()
          FocusFrameSpellBar.Text:SetPoint("TOP", FocusFrameSpellBar, "TOP", 0, 1.5)
          FocusFrameSpellBar.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

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