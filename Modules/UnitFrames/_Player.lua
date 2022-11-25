local Module = SUI:NewModule("UnitFrames.Player");

function Module:OnEnable()
    local db = {
        unitframes = SUI.db.profile.unitframes,
        texture = SUI.db.profile.general.texture,
        nameplates = SUI.db.profile.nameplates.style
    }

    if not db.unitframes.totemicons then
        hooksecurefunc(TotemFrame, "Update", function()
            TotemFrame:Hide()
        end)
    end

    if db.texture ~= [[Interface\Default]] then
        local function updateTextures(self, event)
            if event == "PLAYER_ENTERING_WORLD" then
                self.healthbar:SetStatusBarTexture(db.texture)
                self.healthbar.AnimatedLossBar:SetStatusBarTexture(db.texture)
                self.myHealPredictionBar:SetTexture(db.texture)
                self.otherHealPredictionBar:SetTexture(db.texture)
                self.myManaCostPredictionBar:SetTexture(db.texture)
            end

            local powerColor = GetPowerBarColor(self.manabar.powerType)
            self.manabar.texture:SetTexture(db.texture)
            if self.manabar.powerType == 0 then
                self.manabar:SetStatusBarColor(0, 0.5, 1)
            else
                self.manabar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
            end

            if db.nameplates ~= 'Default' then
                ClassNameplateManaBarFrame:SetStatusBarTexture(db.texture)
            end
        end

        PlayerFrame:HookScript("OnEvent", function(self, event)
            updateTextures(self, event)
        end)

        PetFrame:HookScript("OnEvent", function(self, event)
            if event == "PLAYER_ENTERING_WORLD" then
                self.healthbar:SetStatusBarTexture(db.texture)
            end

            local powerColor = GetPowerBarColor(self.manabar.powerType)
            self.manabar.texture:SetTexture(db.texture)

            if self.manabar.powerType == 0 then
                self.manabar:SetStatusBarColor(0, 0.5, 1)
            else
                self.manabar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
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
