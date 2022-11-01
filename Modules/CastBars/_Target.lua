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
            local tt = TargetFrameSpellBar.Text:GetText()
 
            if(strlen(tt) > 19) then
              local newText = strsub(tt, 0, 19)
              TargetFrameSpellBar.Text:SetText(newText.."...")
            end
          end)
        end
    end
end