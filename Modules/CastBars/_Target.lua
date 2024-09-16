local Module = SUI:NewModule("CastBars.Target");

function Module:OnEnable()
    local db = SUI.db.profile.castbars

    if (db.style == 'Custom' and db.targetCastbar) then
        if (db.targetOnTop) then
            TargetFrameSpellBar:HookScript("OnUpdate", function(self)
                self:ClearAllPoints()
                self:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 45, 0)
            end)
        end

        TargetFrameSpellBar:HookScript("OnEvent", function(self)
            if self:IsForbidden() then return end
            if InCombatLockdown() then return end

            if db.targetSize then
                self:SetScale(db.targetSize)
            end

            self.Icon:SetSize(16, 16)
            self.Icon:ClearAllPoints()
            self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", -20, 2)
            self.BorderShield:ClearAllPoints()
            self.BorderShield:SetPoint("CENTER", self.Icon, "CENTER", 0, -2.5)
            self:SetSize(150, 12)
            self.TextBorder:ClearAllPoints()
            self.TextBorder:SetAlpha(0)
            self.Text:ClearAllPoints()
            self.Text:SetPoint("TOP", self, "TOP", 0, 2.5)
            self.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
            if SUI:Color() then
                self.Border:SetVertexColor(unpack(SUI:Color(0.15)))
                self.Background:SetVertexColor(unpack(SUI:Color(0.15)))
            end
            

            if not db.icon then
                self.Icon:Hide()
            end

            local castText = self.Text:GetText()
            if castText ~= nil then
                if (strlen(castText) > 19) then
                    local newCastText = strsub(castText, 0, 19)
                    self.Text:SetText(newCastText .. "...")
                end
            end
        end)
    end
end
