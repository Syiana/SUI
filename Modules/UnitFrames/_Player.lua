local Module = SUI:NewModule("UnitFrames.Player");

function Module:OnEnable()
    local db = {
        style = SUI.db.profile.unitframes.style,
        pvpbade = SUI.db.profile.unitframes.pvpbade,
        texture = SUI.db.profile.general.texture,
        size = SUI.db.profile.unitframes.size,
        module = SUI.db.profile.modules.unitframes
    }

    if (db.module) then
        local function SUIPlayerFrame(self)
            if (db.texture ~= 'Default') then
                self.healthbar:SetStatusBarTexture(db.texture);
                --self.healthbar.AnimatedLossBar:SetStatusBarTexture(db.texture);
                PlayerFrameHealthBar.MyHealPredictionBar.Fill:SetTexture(db.texture)
                PlayerFrameHealthBar.MyHealPredictionBar.Fill:SetDrawLayer("BORDER")

                --PlayerFrameHealthBar.MyHealPredictionBar.FillMask:SetTexture(db.texture)
                --PlayerFrameHealthBar.MyHealPredictionBar.FillMask:GetTexture()
                PlayerFrameAlternateManaBar:SetStatusBarTexture(db.texture)
                -- PlayerFrameManaBar.FeedbackFrame.BarTexture:SetTexture(db.texture);
                -- PlayerFrameManaBar.FeedbackFrame.LossGlowTexture:SetTexture(db.texture);
                -- PlayerFrameManaBar.FeedbackFrame.GainGlowTexture:SetTexture(db.texture);
            end

            if (db.style == "Big") then
                PlayerFrameTexture:SetTexture([[Interface\Addons\SUI\Media\Textures\UnitFrames\UI-TargetingFrame]]);
                self.name:ClearAllPoints();
                self.name:SetPoint("CENTER", PlayerFrame, "CENTER", 50.5, 36);
                self.healthbar:SetPoint("TOPLEFT", 106, -24);
                self.healthbar:SetHeight(26);
                self.healthbar.LeftText:ClearAllPoints();
                self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 8, 0);
                self.healthbar.RightText:ClearAllPoints();
                self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -5, 0);
                self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0);
                self.manabar:SetPoint("TOPLEFT", 106, -52);
                self.manabar:SetHeight(13);
                self.manabar.LeftText:ClearAllPoints();
                self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 8, 0);
                self.manabar.RightText:ClearAllPoints();
                self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -5, 0);
                self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 0);
                -- self.manabar.FullPowerFrame.SpikeFrame.AlertSpikeStay:ClearAllPoints();
                -- self.manabar.FullPowerFrame.SpikeFrame.AlertSpikeStay:SetPoint("CENTER", self.manabar.FullPowerFrame, "RIGHT", -6, -3);
                -- self.manabar.FullPowerFrame.SpikeFrame.AlertSpikeStay:SetSize(30,29);
                -- self.manabar.FullPowerFrame.PulseFrame:ClearAllPoints();
                -- self.manabar.FullPowerFrame.PulseFrame:SetPoint("CENTER", self.manabar.FullPowerFrame,"CENTER",-6,-2);
                -- self.manabar.FullPowerFrame.SpikeFrame.BigSpikeGlow:ClearAllPoints();
                -- self.manabar.FullPowerFrame.SpikeFrame.BigSpikeGlow:SetPoint("CENTER",self.manabar.FullPowerFrame,"RIGHT",5,-4);
                -- self.manabar.FullPowerFrame.SpikeFrame.BigSpikeGlow:SetSize(30,50);
                PlayerFrameGroupIndicatorText:ClearAllPoints();
                PlayerFrameGroupIndicatorText:SetPoint("BOTTOMLEFT", PlayerFrame, "TOP", 0, -20);
                PlayerFrameGroupIndicatorLeft:Hide();
                PlayerFrameGroupIndicatorMiddle:Hide();
                PlayerFrameGroupIndicatorRight:Hide();
            end

            if not (db.pvpbadge) then
                hooksecurefunc("PlayerFrame_UpdatePvPStatus", function()
                    PlayerPVPIcon:Hide()
                end)
            end
        end

        local Size = CreateFrame("Frame")
        Size:RegisterEvent("ADDON_LOADED")
        Size:SetScript("OnEvent", function()
            PlayerFrame:SetScale(db.size)
        end)

        hooksecurefunc("PlayerFrame_ToPlayerArt", SUIPlayerFrame)
    end
end
