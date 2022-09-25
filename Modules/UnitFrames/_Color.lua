local Module = SUI:NewModule("UnitFrames.Colors");

function Module:OnEnable()
    local db = SUI.db.profile.unitframes

    if (db) then
        if (db.classcolor) then
            function SUIUnitClass(statusbar, unit)
                if UnitIsPlayer(unit) and UnitClass(unit) then
                    _, class = UnitClass(unit);
                    local c = RAID_CLASS_COLORS[class];
                    statusbar:SetStatusBarColor(c.r, c.g, c.b);
                    if c then statusbar:SetStatusBarColor(c.r, c.g, c.b) end
                elseif UnitIsPlayer(unit) and (not UnitIsConnected(unit)) then
                    statusbar:SetStatusBarColor(0.5,0.5,0.5);
                elseif not UnitIsPlayer(unit) then
                    local red, green = UnitSelectionColor("target")
                    if red == 0 then
                        statusbar:SetStatusBarColor(0, .9, 0)
                    elseif green == 0 then
                        statusbar:SetStatusBarColor(1, .1, .1)
                    else
                        statusbar:SetStatusBarColor(1, .8, .1)
                    end
                else
                    statusbar:SetStatusBarColor(0,0.9,0);
                end
            end
            hooksecurefunc("UnitFrameHealthBar_Update", SUIUnitClass)
            hooksecurefunc("HealthBar_OnValueChanged", function(self)
                SUIUnitClass(self, self.unit)
            end)
        end
    end
end