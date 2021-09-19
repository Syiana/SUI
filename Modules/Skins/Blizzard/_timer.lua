local Module = SUI:NewModule("Skins.Bags");

function Module:OnEnable()
    TimerTracker:HookScript("OnEvent", function(self, event, timerType, timeSeconds, totalTime)
        for i = 1, #self.timerList do
          _G['TimerTrackerTimer'..i..'StatusBarBorder']:SetVertexColor(unpack(color.primary))
        end
      end)
      for _, region in pairs({StopwatchFrame:GetRegions()}) do
        region:SetVertexColor(unpack(color.secondary))
      end
end