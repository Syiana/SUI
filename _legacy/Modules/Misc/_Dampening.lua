local Module = SUI:NewModule("Misc.Dampening");

function Module:OnEnable()
    local db = SUI.db.profile.misc.dampening
    if (db) then
        local frame = CreateFrame("Frame", "Dampening_Display", UIParent, "UIWidgetTemplateIconAndText")
        local _
        local spellInfo = C_Spell.GetSpellInfo(110310)
        local widgetSetID = C_UIWidgetManager.GetTopCenterWidgetSetID()
        local widgetSetInfo = C_UIWidgetManager.GetWidgetSetInfo(widgetSetID)
        local C_Commentator_GetDampeningPercent = C_Commentator.GetDampeningPercent

        frame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:SetPoint(UIWidgetTopCenterContainerFrame.verticalAnchorPoint, UIWidgetTopCenterContainerFrame,
            UIWidgetTopCenterContainerFrame.verticalRelativePoint, 0, widgetSetInfo.verticalPadding)
        frame.Text:SetParent(frame)
        frame:SetWidth(200)
        frame.Text:SetAllPoints()
        frame.Text:SetJustifyH("CENTER")

        function frame:UNIT_AURA(unit)
            local percentage = C_Commentator_GetDampeningPercent()
            if percentage and percentage > 0 then
                if not self:IsShown() then
                    self:Show()
                end
                if self.dampening ~= percentage then
                    self.dampening = percentage
                    self.Text:SetText(spellInfo.name .. ": " .. percentage .. "%")
                end
            elseif self:IsShown() then
                self:Hide()
            end
        end

        function frame:PLAYER_ENTERING_WORLD()
            local _, instanceType = IsInInstance()
            if instanceType == "arena" then
                self:RegisterUnitEvent("UNIT_AURA", "player")
            else
                self:UnregisterEvent("UNIT_AURA")
                self:Hide()
            end
        end
    end
end
