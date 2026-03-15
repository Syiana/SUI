local Module = SUI:NewModule("UnitFrames.Core");

function Module:RefreshTextures()
    local texture = SUI.db.profile.general.texture
    if SUI.db.profile.unitframes.style == "Classic" or texture == [[Interface\Default]] then
        return
    end

    if AlternatePowerBar then
        local powerColor = PowerBarColor[AlternatePowerBar.powerType]
        AlternatePowerBar:SetStatusBarTexture(texture)
        if AlternatePowerBar.powerType == 0 then
            AlternatePowerBar:SetStatusBarColor(0, 0.5, 1)
        elseif powerColor then
            AlternatePowerBar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
        end
    end
end

function Module:OnEnable()
    local db = {
        texture = SUI.db.profile.general.texture,
        unitframes = SUI.db.profile.unitframes
    }

    if db.unitframes.style == "Classic" then
        return
    end

    if db.texture ~= [[Interface\Default]] then
        local function manaTexture(self)
            if self and self.powerType then
                if self.unit ~= 'player' then
                    -- Get Power Color
                    local powerColor = PowerBarColor[self.powerType]

                    -- Set Texture
                    self.texture:SetTexture(db.texture)

                    -- Set Power Color
                    if self.unitFrame and self.unitFrame.manabar then
                        if self.powerType == 0 then
                            self.unitFrame.manabar:SetStatusBarColor(0, 0.5, 1)
                        else
                            self.unitFrame.manabar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
                        end
                    end
                end
            end
        end

        local function alternatePowerTexture(self)
            if self then
                local powerColor = PowerBarColor[self.powerType]
                self:SetStatusBarTexture(db.texture)
                if self.powerType and self.powerType == 0 then
                    self:SetStatusBarColor(0, 0.5, 1)
                elseif self.powerType and self.powerType ~= 0 then
                    self:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
                end
            end
        end

        hooksecurefunc("UnitFrameManaBar_Update", function(self)
            manaTexture(self)
        end)

        AlternatePowerBar:HookScript("OnEvent", alternatePowerTexture)
    end
end
