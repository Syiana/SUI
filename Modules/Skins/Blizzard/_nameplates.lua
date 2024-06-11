local Module = SUI:NewModule("Skins.Nameplates");

function Module:OnEnable()
    hooksecurefunc("CompactUnitFrame_UpdateHealth", function(self)
        if self:IsForbidden() then return end

        if self.unit and self.unit:find('nameplate%d') then
            SUI:Skin(self.healthBar.border)
            SUI:Skin({ self.CastBar.Border, self.CastBar.BorderShield }, false, true)
        end
    end)
end
