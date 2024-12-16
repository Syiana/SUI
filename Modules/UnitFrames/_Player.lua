local Module = SUI:NewModule("UnitFrames.Player");

function Module:OnEnable()
    local db = {
        style = SUI.db.profile.unitframes.style,
        pvpbadge = SUI.db.profile.unitframes.pvpbadge,
        texture = SUI.db.profile.general.texture,
        size = SUI.db.profile.unitframes.size,
        module = SUI.db.profile.modules.unitframes,
        elite = SUI.db.profile.unitframes.elite
    }

    if (db.module) then
        -- Set Frame Scale
        PlayerFrame:SetScale(db.size)

        local function SUIPlayerFrame(self)
            if (db.texture ~= 'Default') then
                self.healthbar:SetStatusBarTexture(db.texture);
                PlayerFrameHealthBar.MyHealPredictionBar.Fill:SetTexture(db.texture)
                PlayerFrameHealthBar.MyHealPredictionBar.Fill:SetDrawLayer("BORDER")
            end

            if (db.style == "Big") then
                PlayerFrameGroupIndicator:SetAlpha(0)
                if db.elite then
                    PlayerFrameTexture:SetTexture(
                        [[Interface\Addons\SUI\Media\Textures\UnitFrames\UI-TargetingFrame-Rare-Elite]]);
                else
                    PlayerFrameTexture:SetTexture([[Interface\Addons\SUI\Media\Textures\UnitFrames\UI-TargetingFrame]]);
                end
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
                PlayerFrameGroupIndicatorText:ClearAllPoints();
                PlayerFrameGroupIndicatorText:SetPoint("BOTTOMLEFT", PlayerFrame, "TOP", 0, -20);
                PlayerFrameGroupIndicatorLeft:Hide();
                PlayerFrameGroupIndicatorMiddle:Hide();
                PlayerFrameGroupIndicatorRight:Hide();
            end
        end

        if not (db.pvpbadge) then
            hooksecurefunc("PlayerFrame_UpdatePvPStatus", function()
                PlayerPVPIcon:Hide()
            end)
        end

        hooksecurefunc("PlayerFrame_ToPlayerArt", SUIPlayerFrame)
    end
end
