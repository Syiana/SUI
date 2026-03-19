local Module = SUI:NewModule("UnitFrames.Player");

local function setCornerIconShown()
    local icon = PlayerFrame and PlayerFrame.PlayerFrameContent and PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual and
        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon
    if not icon then
        return
    end

    icon:SetShown(SUI.db.profile.unitframes.cornericon)
end

function Module:RefreshTextures()
    local texture = SUI.db.profile.general.texture
    if SUI.db.profile.unitframes.style == "Classic" or texture == [[Interface\Default]] then
        return
    end

    if PlayerFrame and PlayerFrame.healthbar then
        PlayerFrame.healthbar:SetStatusBarTexture(texture)
        PlayerFrame.healthbar:GetStatusBarTexture():SetDrawLayer("BORDER")
        if PlayerFrame.healthbar.AnimatedLossBar then
            PlayerFrame.healthbar.AnimatedLossBar:SetStatusBarTexture(texture)
            PlayerFrame.healthbar.AnimatedLossBar:GetStatusBarTexture():SetDrawLayer("BORDER")
        end
    end

    if PlayerFrame and PlayerFrame.manabar and PlayerFrame.manabar.texture then
        local powerColor = PowerBarColor[PlayerFrame.manabar.powerType]
        PlayerFrame.manabar.texture:SetTexture(texture)
        if PlayerFrame.manabar.powerType == 0 then
            PlayerFrame.manabar:SetStatusBarColor(0, 0.5, 1)
        elseif powerColor then
            PlayerFrame.manabar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
        end
    end

    if PetFrame and PetFrame.healthbar then
        PetFrame.healthbar:SetStatusBarTexture(texture)
        PetFrame.healthbar:GetStatusBarTexture():SetDrawLayer("BORDER")
    end
end

function Module:RefreshVisibility()
    setCornerIconShown()
end

function Module:OnEnable()
    local db = {
        unitframes = SUI.db.profile.unitframes,
        texture = SUI.db.profile.general.texture,
        classbar = SUI.db.profile.unitframes.classbar
    }
    local isClassic = db.unitframes.style == "Classic"

    if not db.unitframes.totemicons then
        hooksecurefunc(TotemFrame, "Update", function()
            TotemFrame:Hide()
        end)
    end

    if not isClassic and db.texture ~= [[Interface\Default]] then
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

            setCornerIconShown()
        end)

        PetFrame:HookScript("OnEvent", function(self, event)
            if event == "PLAYER_ENTERING_WORLD" then
                self.healthbar:SetStatusBarTexture(db.texture)
                self.healthbar:GetStatusBarTexture():SetDrawLayer("BORDER")
            end
        end)
    end

    if not db.classbar then
        if RogueComboPointBarFrame then
            RogueComboPointBarFrame:HookScript("OnEvent", function()
                RogueComboPointBarFrame:Hide()
                RogueComboPointBarFrame.Show = function() end
            end)
        end

        if MageArcaneChargesFrame then
            MageArcaneChargesFrame:HookScript("OnEvent", function()
                MageArcaneChargesFrame:Hide()
                MageArcaneChargesFrame.Show = function() end
            end)
        end

        if WarlockPowerFrame then
            WarlockPowerFrame:HookScript("OnEvent", function()
                WarlockPowerFrame:Hide()
                WarlockPowerFrame.Show = function() end
            end)
        end

        if DruidComboPointBarFrame then
            DruidComboPointBarFrame:HookScript("OnEvent", function()
                DruidComboPointBarFrame:Hide()
                DruidComboPointBarFrame.Show = function() end
            end)
        end

        if MonkHarmonyBarFrame then
            MonkHarmonyBarFrame:HookScript("OnEvent", function()
                MonkHarmonyBarFrame:Hide()
                MonkHarmonyBarFrame.Show = function() end
            end)
        end

        if EssencePlayerFrame then
            EssencePlayerFrame:HookScript("OnEvent", function()
                EssencePlayerFrame:Hide()
                EssencePlayerFrame.Show = function() end
            end)
        end

        if RuneFrame then
            RuneFrame:HookScript("OnEvent", function()
                RuneFrame:Hide()
                RuneFrame.Show = function() end
            end)
        end

        if PaladinPowerBarFrame then
            PaladinPowerBarFrame:HookScript("OnEvent", function()
                PaladinPowerBarFrame:Hide()
                PaladinPowerBarFrame.Show = function() end
            end)
        end
    end

    if isClassic then
        return
    end

    local statusTexture = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture;
    local statusAnimation = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop

    hooksecurefunc("PlayerFrame_UpdateStatus", function(self)
        if (IsResting()) then
            statusTexture:Hide()
            statusAnimation:Hide()
        end
    end)

    Module:RefreshVisibility()
end
