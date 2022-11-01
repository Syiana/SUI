local Module = SUI:NewModule("CastBars.Player");

function Module:OnEnable()
  local db = SUI.db.profile.castbars
  if (db.style == 'Custom') then
        if not InCombatLockdown() then
            PlayerCastingBarFrame.Icon:Show()
            PlayerCastingBarFrame:SetSize(209, 18)
            PlayerCastingBarFrame.TextBorder:ClearAllPoints()
            PlayerCastingBarFrame.TextBorder:SetAlpha(0)
            PlayerCastingBarFrame.Text:ClearAllPoints()
            PlayerCastingBarFrame.Text:SetPoint("TOP", PlayerCastingBarFrame, "TOP", 0, -1)
            PlayerCastingBarFrame.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
        end
    end
end