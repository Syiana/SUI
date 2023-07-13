local Module = SUI:NewModule("UnitFrames.Core");

function Module:OnEnable()
    local db = {
        texture = SUI.db.profile.general.texture
    }

    if db.texture ~= [[Interface\Default]] then
        local function manaTexture(self)
            if self and self.unitFrame then
                local unitframe = self.unitFrame

                if unitframe.manabar then
                    -- Set Textures
                    local powerColor = GetPowerBarColor(unitframe.manabar.powerType)
                    unitframe.manabar.texture:SetTexture(db.texture)

                    if unitframe.manabar.powerType == 0 then
                        unitframe.manabar:SetStatusBarColor(0, 0.5, 1)
                    else
                        unitframe.manabar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
                    end
                end
            end
        end

        local function alternatePowerTexture(self)
            if self then
                local powerColor = GetPowerBarColor(self.powerType)
                self:SetStatusBarTexture(db.texture)
                if self.powerType == 0 then
                    self:SetStatusBarColor(0, 0,5, 1)
                else
                    self:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
                end
            end
        end

        hooksecurefunc("UnitFrameManaBar_UpdateType", function(self)
            manaTexture(self)
        end)

        AlternatePowerBar:HookScript("OnEvent", alternatePowerTexture)
    end
end