local Module = SUI:NewModule("Skins.Timer");

function Module:OnEnable()
    if (SUI:Color()) then
        local db = SUI.db.profile.general.texture

        TimerTracker:HookScript("OnEvent", function(self, event, timerType, timeSeconds, totalTime)
            for i = 1, #self.timerList do
                local border = _G['TimerTrackerTimer' .. i .. 'StatusBarBorder']

                border:SetVertexColor(unpack(SUI:Color()))
            end
        end)
        for _, region in pairs({ StopwatchFrame:GetRegions() }) do
            region:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end
