local Module = SUI:NewModule("Skins.Timer");

function Module:OnEnable()
    if (SUI:Color()) then
        local db = SUI.db.profile.general.texture

        TimerTracker:HookScript("OnEvent", function(self, event, timerType, timeSeconds, totalTime)
            for i = 1, #self.timerList do
                local timer = _G['TimerTrackerTimer' .. i]
                local border = _G['TimerTrackerTimer' .. i .. 'StatusBarBorder']
                local statusbar = _G['TimerTrackerTimer' .. i .. 'StatusBar']

                border:SetVertexColor(unpack(SUI:Color()))

                if (db.texture ~= 'Default') then
                    statusbar:SetStatusBarTexture(db.texture)
                    statusbar:GetStatusBarTexture():SetDrawLayer("BORDER")
                else
                    statusbar:SetStatusBarTexture("Interface\\Addons\\SUI\\Media\\Textures\\Unitframes\\UI-StatusBar")
                    statusbar:GetStatusBarTexture():SetDrawLayer("BORDER")
                end
            end
        end)
        for _, region in pairs({ StopwatchFrame:GetRegions() }) do
            region:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end
