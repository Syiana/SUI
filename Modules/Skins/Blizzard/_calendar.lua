local Module = SUI:NewModule("Skins.Calendar");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Calendar" then
                for i, v in pairs({ CalendarFrameTopMiddleTexture,
                    CalendarFrameRightTopTexture,
                    CalendarFrameRightMiddleTexture,
                    CalendarFrameRightBottomTexture,
                    CalendarFrameBottomRightTexture,
                    CalendarFrameBottomMiddleTexture,
                    CalendarFrameBottomLeftTexture,
                    CalendarFrameLeftMiddleTexture,
                    CalendarFrameLeftTopTexture,
                    CalendarFrameLeftBottomTexture,
                    CalendarFrameTopLeftTexture,
                    CalendarFrameTopRightTexture,
                    CalendarCreateEventDivider,
                    CalendarCreateEventFrameButtonBackground,
                    CalendarCreateEventMassInviteButtonBorder,
                    CalendarCreateEventCreateButtonBorder,
                    CalendarCreateEventFrame.Header.LeftBG,
                    CalendarCreateEventFrame.Header.CenterBG,
                    CalendarCreateEventFrame.Header.RightBG,
                    CalendarCreateEventFrame.Border.TopEdge,
                    CalendarCreateEventFrame.Border.RightEdge,
                    CalendarCreateEventFrame.Border.BottomEdge,
                    CalendarCreateEventFrame.Border.LeftEdge,
                    CalendarCreateEventFrame.Border.TopRightCorner,
                    CalendarCreateEventFrame.Border.TopLeftCorner,
                    CalendarCreateEventFrame.Border.BottomLeftCorner,
                    CalendarCreateEventFrame.Border.BottomRightCorner,
                    CalendarViewHolidayFrame.Border.TopEdge,
                    CalendarViewHolidayFrame.Border.RightEdge,
                    CalendarViewHolidayFrame.Border.BottomEdge,
                    CalendarViewHolidayFrame.Border.LeftEdge,
                    CalendarViewHolidayFrame.Border.TopRightCorner,
                    CalendarViewHolidayFrame.Border.TopLeftCorner,
                    CalendarViewHolidayFrame.Border.BottomLeftCorner,
                    CalendarViewHolidayFrame.Border.BottomRightCorner,
                    CalendarViewHolidayFrame.Header.LeftBG,
                    CalendarViewHolidayFrame.Header.CenterBG,
                    CalendarViewHolidayFrame.Header.RightBG
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
                
            end
        end)
    end
end
