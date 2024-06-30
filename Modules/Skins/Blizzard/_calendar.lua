local Module = SUI:NewModule("Skins.Calendar");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Calendar" then
                SUI:Skin(CalendarFrame)
                SUI:Skin(CalendarFilterFrame)
                SUI:Skin(CalendarCreateEventFrame)
                SUI:Skin(CalendarCreateEventFrame.Header)
                SUI:Skin(CalendarCreateEventFrame.Border)
                SUI:Skin(CalendarCreateEventMassInviteButton)
                SUI:Skin(CalendarCreateEventCreateButton)
                SUI:Skin(CalendarCreateEventInviteButton)
                SUI:Skin(CalendarCreateEventRaidInviteButton)
                SUI:Skin(CalendarCreateEventHourDropDown)
                SUI:Skin(CalendarCreateEventMinuteDropDown)
                SUI:Skin(CalendarCreateEventAMPMDropDown)
                SUI:Skin(CalendarCreateEventTypeDropDown)
                SUI:Skin(CalendarCreateEventInviteList.NineSlice)
                SUI:Skin(CalendarCreateEventDescriptionContainer.NineSlice)
                SUI:Skin(CalendarCreateEventInviteEdit)
                SUI:Skin(CalendarCreateEventTitleEdit)
                SUI:Skin(CalendarViewHolidayFrame.Header)
                SUI:Skin(CalendarViewHolidayFrame.Border)
                SUI:Skin(CalendarViewRaidFrame.Header)
                SUI:Skin(CalendarViewRaidFrame.Border)
                SUI:Skin(CalendarClassButton1)
                SUI:Skin(CalendarClassButton2)
                SUI:Skin(CalendarClassButton3)
                SUI:Skin(CalendarClassButton4)
                SUI:Skin(CalendarClassButton5)
                SUI:Skin(CalendarClassButton6)
                SUI:Skin(CalendarClassButton7)
                SUI:Skin(CalendarClassButton8)
                SUI:Skin(CalendarClassButton9)
                SUI:Skin(CalendarClassButton10)
                SUI:Skin(CalendarClassTotalsButton)

                -- Reset Icon colors
                select(5, CalendarViewHolidayCloseButton:GetRegions()):Hide()
                select(5, CalendarViewRaidCloseButton:GetRegions()):Hide()
                select(5, CalendarCreateEventCloseButton:GetRegions()):Hide()
                select(3, CalendarClassButton1:GetRegions()):SetVertexColor(1,1,1)
                select(3, CalendarClassButton2:GetRegions()):SetVertexColor(1,1,1)
                select(3, CalendarClassButton3:GetRegions()):SetVertexColor(1,1,1)
                select(3, CalendarClassButton4:GetRegions()):SetVertexColor(1,1,1)
                select(3, CalendarClassButton5:GetRegions()):SetVertexColor(1,1,1)
                select(3, CalendarClassButton6:GetRegions()):SetVertexColor(1,1,1)
                select(3, CalendarClassButton7:GetRegions()):SetVertexColor(1,1,1)
                select(3, CalendarClassButton8:GetRegions()):SetVertexColor(1,1,1)
                select(3, CalendarClassButton9:GetRegions()):SetVertexColor(1,1,1)
                select(3, CalendarClassButton10:GetRegions()):SetVertexColor(1,1,1)

                -- Buttons
                SUI:Skin({
                    CalendarCreateEventMassInviteButton.Left,
                    CalendarCreateEventMassInviteButton.Middle,
                    CalendarCreateEventMassInviteButton.Right,
                    CalendarCreateEventCreateButton.Left,
                    CalendarCreateEventCreateButton.Middle,
                    CalendarCreateEventCreateButton.Right,
                    CalendarCreateEventInviteButton.Left,
                    CalendarCreateEventInviteButton.Middle,
                    CalendarCreateEventInviteButton.Right,
                    CalendarCreateEventRaidInviteButton.Left,
                    CalendarCreateEventRaidInviteButton.Middle,
                    CalendarCreateEventRaidInviteButton.Right
                }, false, true, false, true)
            end
        end)
    end
end
