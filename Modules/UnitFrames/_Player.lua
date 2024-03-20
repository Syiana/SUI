local Module = SUI:NewModule("UnitFrames.Player");

function Module:OnEnable()
    local db = {
        unitframes = SUI.db.profile.unitframes,
        texture = SUI.db.profile.general.texture,
        classbar = SUI.db.profile.unitframes.classbar
    }

    if not db.unitframes.totemicons then
        hooksecurefunc(TotemFrame, "Update", function()
            TotemFrame:Hide()
        end)
    end

    if db.texture ~= [[Interface\Default]] then
        local function healthTexture(self, event)
            if event == "PLAYER_ENTERING_WORLD" then
                self.healthbar:SetStatusBarTexture(db.texture)
                self.healthbar:GetStatusBarTexture():SetDrawLayer("BORDER")
                self.healthbar.AnimatedLossBar:SetStatusBarTexture(db.texture)
                self.healthbar.AnimatedLossBar:GetStatusBarTexture():SetDrawLayer("BORDER")
            end
        end

        local function manaTexture(self)
            if self and self.manabar then
                -- Get Power Color
                local powerColor = PowerBarColor[self.manabar.powerType]

                -- Set Texture
                self.manabar.texture:SetTexture(db.texture)

                -- Set Power Color
                if self.manabar.powerType == 0 then
                    self.manabar:SetStatusBarColor(0, 0.5, 1)
                else
                    self.manabar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
                end
            end
        end

        PlayerFrame:HookScript("OnEvent", function(self, event)
            healthTexture(self, event)
            manaTexture(self, event)

            if not db.unitframes.cornericon then
                PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:Hide()
            end

            if not db.unitframes.level then
                local MAX_PLAYER_LEVEL = GetMaxLevelForPlayerExpansion()
                if UnitLevel("player") >= MAX_PLAYER_LEVEL then
                    PlayerLevelText:Hide()
                end
            end

            if not db.classbar then
                if RogueComboPointBarFrame then
                    RogueComboPointBarFrame:Hide()
                end

                if MageArcaneChargesFrame then
                    MageArcaneChargesFrame:Hide()
                end

                if WarlockPowerFrame then
                    WarlockPowerFrame:Hide()
                end

                if DruidComboPointBarFrame then
                    DruidComboPointBarFrame:Hide()
                end

                if MonkHarmonyBarFrame then
                    MonkHarmonyBarFrame:Hide()
                end

                if EssencePlayerFrame then
                    EssencePlayerFrame:Hide()
                end

                if RuneFrame then
                    RuneFrame:Hide()
                end

                if PaladinPowerBarFrame then
                    PaladinPowerBarFrame:HookScript("OnUpdate", function()
                        PaladinPowerBarFrame:Hide()
                    end)
                end
            end
        end)

        PetFrame:HookScript("OnEvent", function(self, event)
            if event == "PLAYER_ENTERING_WORLD" then
                self.healthbar:SetStatusBarTexture(db.texture)
                self.healthbar:GetStatusBarTexture():SetDrawLayer("BORDER")
            end
        end)
    end

    local statusTexture = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture;
    local statusAnimation = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop

    hooksecurefunc("PlayerFrame_UpdateStatus", function(self)
        if (IsResting()) then
            statusTexture:Hide()
            statusAnimation:Hide()
        end
    end)
end
