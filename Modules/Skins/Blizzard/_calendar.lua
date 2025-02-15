local Module = SUI:NewModule("Skins.Calendar");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Calendar" then
                SUI:Skin(CalendarFrame, true)
                SUI:Skin(CalendarCreateEventFrame, true)
                SUI:Skin(CalendarCreateEventFrame.Header, true)
                SUI:Skin(CalendarCreateEventFrame.Border, true)
                SUI:Skin(CalendarViewHolidayFrame, true)
                SUI:Skin(CalendarViewHolidayFrame.Header, true)
                SUI:Skin(CalendarViewHolidayFrame.Border, true)
                SUI:Skin({
                    CalendarCreateEventDivider,
                    CalendarCreateEventFrameButtonBackground,
                    CalendarCreateEventMassInviteButtonBorder,
                    CalendarCreateEventCreateButtonBorder
                }, true, true)
            end
        end)
    end
end
