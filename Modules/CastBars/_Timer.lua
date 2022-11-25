local Module = SUI:NewModule("CastBars.Timer");

function Module:OnEnable()
    local db = SUI.db.profile.castbars
    if (db.timer) then
        local format = string.format
        local max = math.max
        local FONT = STANDARD_TEXT_FONT

        if not InCombatLockdown() then
            PlayerCastingBarFrame.timer = PlayerCastingBarFrame:CreateFontString(nil)
            PlayerCastingBarFrame.timer:SetFont(FONT, 14, "THINOUTLINE")
            PlayerCastingBarFrame.timer:SetPoint("LEFT", PlayerCastingBarFrame, "RIGHT", 5, 0)
            PlayerCastingBarFrame.update = 0.1
            TargetFrameSpellBar.timer = TargetFrameSpellBar:CreateFontString(nil)
            TargetFrameSpellBar.timer:SetFont(FONT, 11, "THINOUTLINE")
            TargetFrameSpellBar.timer:SetPoint("LEFT", TargetFrameSpellBar, "RIGHT", 4, 0)
            TargetFrameSpellBar.update = 0.1
            FocusFrameSpellBar.timer = FocusFrameSpellBar:CreateFontString(nil)
            FocusFrameSpellBar.timer:SetFont(FONT, 11, "THINOUTLINE")
            FocusFrameSpellBar.timer:SetPoint("LEFT", FocusFrameSpellBar, "RIGHT", 4, 0)
            FocusFrameSpellBar.update = 0.1
        end

        local function CastingBarFrame_OnUpdate_Hook(self, elapsed)
            if not self.timer then return end
            if self.update and self.update < elapsed then
                if self.casting then
                    self.timer:SetText(format("%.1f", max(self.maxValue - self.value, 0)))
                elseif self.channeling then
                    self.timer:SetText(format("%.1f", max(self.value, 0)))
                else
                    self.timer:SetText("")
                end
                self.update = .1
            else
                self.update = self.update - elapsed
            end
        end

        PlayerCastingBarFrame:HookScript("OnUpdate", CastingBarFrame_OnUpdate_Hook)
        TargetFrameSpellBar:HookScript("OnUpdate", CastingBarFrame_OnUpdate_Hook)
        FocusFrameSpellBar:HookScript("OnUpdate", CastingBarFrame_OnUpdate_Hook)
    end
end
