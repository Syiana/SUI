local Module = SUI:NewModule("Skins.Calendar");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Calendar" then
                SUI:Skin(CalendarFrame)
                SUI:Skin(CalendarCreateEventFrame)
                SUI:Skin(CalendarCreateEventFrame.Header)
                SUI:Skin(CalendarCreateEventFrame.Border)
                SUI:Skin(CalendarViewHolidayFrame)
                SUI:Skin(CalendarViewHolidayFrame.Header)
                SUI:Skin(CalendarViewHolidayFrame.Border)
                SUI:Skin({
                    CalendarCreateEventDivider,
                    CalendarCreateEventFrameButtonBackground,
                    CalendarCreateEventMassInviteButtonBorder,
                    CalendarCreateEventCreateButtonBorder
                }, false, true)
            end
        end)
    end
end
