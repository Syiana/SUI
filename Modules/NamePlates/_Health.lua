local Module = SUI:NewModule("NamePlates.Health");

function Module:OnEnable()
    local db = {
        health = SUI.db.profile.nameplates.health,
        module = SUI.db.profile.modules.nameplates
    }

    local function nameplateHealthText(unit, healthBar)
        if not healthBar.text then
            healthBar.text = healthBar:CreateFontString(nil, "ARTWORK", nil)
            healthBar.text:SetPoint("CENTER")
            healthBar.text:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')
        else
            local _, maxHealth = healthBar:GetMinMaxValues()
            local currentHealth = healthBar:GetValue()
            healthBar.text:SetText(string.format(math.floor((currentHealth / maxHealth) * 100)) .. "%")
        end
    end

    local function nameplateHealthTextFrame(self)
        if self:IsForbidden() then return end

        if self.unit and self.unit:find('nameplate%d') then
            if self.healthBar and self.unit then
                if UnitName("player") ~= UnitName(self.unit) then
                    local unit = self.unit
                    local healthBar = self.healthBar
                    nameplateHealthText(unit, healthBar)
                end
            end
        end
    end

    if (db.health and db.module) then
        hooksecurefunc("CompactUnitFrame_UpdateHealthColor", nameplateHealthTextFrame)
        hooksecurefunc("CompactUnitFrame_UpdateHealth", nameplateHealthTextFrame)
    end
end
