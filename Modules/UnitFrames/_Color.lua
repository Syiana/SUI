local Module = SUI:NewModule("UnitFrames.Colors")

local function colorHealthBar(healthbar, unit)
    if not healthbar or not unit then
        return
    end

    local db = SUI.db.profile.unitframes
    local texture = SUI.db.profile.general.texture

    if db.classcolor then
        healthbar:SetStatusBarDesaturated(1)
        if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
            local _, class = UnitClass(unit)
            local color = RAID_CLASS_COLORS[class]
            healthbar:SetStatusBarColor(color.r, color.g, color.b)
        elseif UnitIsPlayer(unit) and not UnitIsConnected(unit) then
            healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
        elseif UnitExists(unit) then
            if UnitIsTapDenied(unit) and not UnitPlayerControlled(unit) then
                healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
            else
                local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
                if reaction then
                    healthbar:SetStatusBarColor(reaction.r, reaction.g, reaction.b)
                end
            end
        end
    elseif texture ~= [[Interface\Default]] then
        healthbar:SetStatusBarColor(0, 0.7, 0)
    end
end

function Module:RefreshColors()
    local healthBars = {
        { PlayerFrame and PlayerFrame.healthbar, "player" },
        { TargetFrame and TargetFrame.TargetFrameContent and TargetFrame.TargetFrameContent.TargetFrameContentMain and TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer and TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar, "target" },
        { FocusFrame and FocusFrame.TargetFrameContent and FocusFrame.TargetFrameContent.TargetFrameContentMain and FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer and FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar, "focus" }
    }

    for _, entry in ipairs(healthBars) do
        local healthBar, unit = entry[1], entry[2]
        if healthBar then
            colorHealthBar(healthBar, unit or healthBar.unit)
        end
    end
end

function Module:OnEnable()
    TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor:Hide()
    FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor:Hide()

    local db = SUI.db.profile.unitframes
    local texture = SUI.db.profile.general.texture
    if (db) then
        if (db.classcolor) then
            hooksecurefunc("UnitFrameHealthBar_Update", function(self)
                colorHealthBar(self, self.unit)
            end)
            hooksecurefunc("HealthBar_OnValueChanged", function(self)
                colorHealthBar(self, self.unit)
            end)
        elseif not db.classcolor and texture ~= [[Interface\Default]] then
            hooksecurefunc("UnitFrameHealthBar_Update", function(self)
                colorHealthBar(self, self.unit)
            end)
            hooksecurefunc("HealthBar_OnValueChanged", function(self)
                colorHealthBar(self, self.unit)
            end)
        end
    end

    Module:RefreshColors()
end
