local Module = SUI:NewModule("UnitFrames.Colors");

function Module:OnEnable()
    local db = {
        classcolor = SUI.db.profile.unitframes.classcolor,
        texture = SUI.db.profile.general.texture,
        factioncolor = SUI.db.profile.unitframes.factioncolor
    }

    if (db) then

        if (db.classcolor) then
            function SUIUnitClass(healthbar, unit)
                if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
                    _, class = UnitClass(unit);
                    local c = RAID_CLASS_COLORS[class];
                    healthbar:SetStatusBarColor(c.r, c.g, c.b);
                elseif UnitIsPlayer(unit) and (not UnitIsConnected(unit)) then
                    healthbar:SetStatusBarColor(0.5,0.5,0.5);
                else
                    healthbar:SetStatusBarColor(0,0.9,0);
                end
            end
            hooksecurefunc("UnitFrameHealthBar_Update", SUIUnitClass)
            hooksecurefunc("HealthBar_OnValueChanged", function(self)
                SUIUnitClass(self, self.unit)
            end)
        elseif not db.classcolor and db.texture ~= [[Interface\Default]] then
            function SUIUnitColor(healthbar, unit)
                healthbar:SetStatusBarColor(0, 1, 0)
            end

            hooksecurefunc("UnitFrameHealthBar_Update", function(self)
                SUIUnitColor(self, self.unit)
            end)
            hooksecurefunc("HealthBar_OnValueChanged", function(self)
                SUIUnitColor(self, self.unit)
            end)
        end

        if (db.factioncolor) then
            function SUIUnitReaction(healthbar, unit)
                if UnitExists(unit) and (not UnitIsPlayer(unit)) then
                    if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                        healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
                    elseif (not UnitIsTapDenied(unit)) then
                        local reaction = FACTION_BAR_COLORS[UnitReaction(unit,"player")];
                        if reaction then
                            healthbar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                        else
                            healthbar:SetStatusBarColor(0,0.6,0.1)
                        end
                    end
                end
            end
            hooksecurefunc("UnitFrameHealthBar_Update", SUIUnitReaction)
            hooksecurefunc("HealthBar_OnValueChanged", function(self)
                SUIUnitReaction(self, self.unit)
            end)
        end

    end
end