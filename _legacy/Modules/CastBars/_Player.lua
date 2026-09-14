local Module = SUI:NewModule("CastBars.Player");

function Module:OnEnable()
    local db = SUI.db.profile.castbars

    if (db.style == 'Custom') then
        PlayerCastingBarFrame:HookScript("OnEvent", function()
            PlayerCastingBarFrame.StandardGlow:Hide()
            PlayerCastingBarFrame.TextBorder:Hide()
            PlayerCastingBarFrame:SetSize(209, 18)
            PlayerCastingBarFrame.TextBorder:ClearAllPoints()
            PlayerCastingBarFrame.TextBorder:SetAlpha(0)
            PlayerCastingBarFrame.Border:ClearAllPoints()
            PlayerCastingBarFrame.Border:SetAlpha(0)
            PlayerCastingBarFrame.Text:ClearAllPoints()
            PlayerCastingBarFrame.Text:SetPoint("TOP", PlayerCastingBarFrame, "TOP", 0, -1)
            PlayerCastingBarFrame.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")

            if SUI:Color() then
                PlayerCastingBarFrame.Background:SetVertexColor(unpack(SUI:Color(0.15)))
            end

            if db.icon then
                PlayerCastingBarFrame.Icon:Show()
                PlayerCastingBarFrame.Icon:SetSize(20, 20)
            end
        end)
    end
end
