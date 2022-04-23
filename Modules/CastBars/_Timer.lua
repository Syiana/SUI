local Module = SUI:NewModule("CastBars.Timer");

function Module:OnEnable()
  local db = SUI.db.profile.castbars
    if (db.timer) then
      local format = string.format
      local max = math.max
      local FONT = STANDARD_TEXT_FONT

      local castbars = { 'CastingBarFrame', 'TargetFrameSpellBar', 'FocusFrameSpellBar' }

      if not InCombatLockdown() then
        for key, value in pairs(castbars) do
          local castbar = _G[value]
          castbar.timer = castbar:CreateFontString(nil)
          castbar.timer:SetFont(FONT, 14, "THINOUTLINE")
          castbar.timer:SetPoint("LEFT", castbar, "RIGHT", 5, 0)
          castbar.update = 0.1
        end
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
      CastingBarFrame:HookScript("OnUpdate", CastingBarFrame_OnUpdate_Hook)
      TargetFrameSpellBar:HookScript("OnUpdate", CastingBarFrame_OnUpdate_Hook)
      FocusFrameSpellBar:HookScript("OnUpdate", CastingBarFrame_OnUpdate_Hook)
    end
end