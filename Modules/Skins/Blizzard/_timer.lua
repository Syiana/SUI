local Module = SUI:NewModule("Skins.Timer");

function Module:OnEnable()
    if (SUI:Color()) then
        TimerTracker:HookScript("OnEvent", function(self, event, timerType, timeSeconds, totalTime)
            for i = 1, #self.timerList do
                _G['TimerTrackerTimer' .. i .. 'StatusBarBorder']:SetVertexColor(unpack(SUI:Color(0.15)))
            end
        end)
        for _, region in pairs({ StopwatchFrame:GetRegions() }) do
            region:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end
