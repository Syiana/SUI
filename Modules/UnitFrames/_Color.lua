local Module = SUI:NewModule("UnitFrames.Colors")

function Module:OnEnable()
    function SUIUnitColor(healthbar, unit)
        healthbar:SetStatusBarDesaturated(1)
        if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
            _, class = UnitClass(unit)
            local color = RAID_CLASS_COLORS[class]
            healthbar:SetStatusBarColor(color.r, color.g, color.b)
        elseif UnitIsPlayer(unit) and (not UnitIsConnected(unit)) then
            HealthBar:SetStatusBarColor(0.5, 0.5, 0.5);
        else
            healthbar:SetStatusBarColor(0, 0.9, 0);
        end
    end

    hooksecurefunc("UnitFrameHealthBar_Update", function(self)
        SUIUnitColor(self, self.unit)
    end)
    hooksecurefunc("HealthBar_OnValueChanged", function(self)
        SUIUnitColor(self, self.unit)
    end)
end