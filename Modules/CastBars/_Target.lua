local Module = SUI:NewModule("CastBars.Target");

function Module:OnEnable()
  local db = SUI.db.profile.castbars
    if (db.style == 'Custom' and db.targetCastbar) then
        if not InCombatLockdown() then
          TargetFrameSpellBar.Icon:Show()
          TargetFrameSpellBar.Icon:SetSize(16, 16)
          TargetFrameSpellBar.Icon:ClearAllPoints()
          TargetFrameSpellBar.Icon:SetPoint("TOPLEFT", TargetFrameSpellBar, "TOPLEFT", -20, 2)
          TargetFrameSpellBar:SetSize(150, 12)
          TargetFrameSpellBar.TextBorder:ClearAllPoints()
          TargetFrameSpellBar.TextBorder:SetAlpha(0)
          TargetFrameSpellBar.Text:ClearAllPoints()
          TargetFrameSpellBar.Text:SetPoint("TOP", TargetFrameSpellBar, "TOP", 0, 1.5)
          TargetFrameSpellBar.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

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