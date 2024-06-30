local Module = SUI:NewModule("Skins.Timer");

function Module:OnEnable()
    if (SUI:Color()) then
        local db = {
            texture = SUI.db.profile.general.texture,
            style = SUI.db.profile.castbars.style
        }

        TimerTracker:HookScript("OnEvent", function(self, event, timerType, timeSeconds, totalTime)
            for i = 1, #self.timerList do
                local border = _G['TimerTrackerTimer' .. i .. 'StatusBarBorder']
                local statusbar = _G['TimerTrackerTimer' .. i .. 'StatusBar']                

                if (db.texture ~= 'Default') then
                    statusbar:SetStatusBarTexture(db.texture)
                end

                if (db.style == 'Custom') then
                    border:SetTexture([[Interface\CastingBar\UI-CastingBar-Border-Small]])
                    border:SetDrawLayer("OVERLAY", 1)
                end

                border:SetVertexColor(unpack(SUI:Color()))
            end
        end)
        for _, region in pairs({ StopwatchFrame:GetRegions() }) do
            region:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end