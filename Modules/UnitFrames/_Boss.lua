local Module = SUI:NewModule("UnitFrames.Boss");
function Module:OnEnable()
    local db = SUI.db.profile.general
    function SUIBossFrames(self, event)
        if self then
            if self.healthbar then
                self.healthbar:SetStatusBarTexture(db.texture)
            end

            if self.TargetFrameContent.TargetFrameContentMain.ReputationColor and SUI:Color() then
                self.TargetFrameContent.TargetFrameContentMain.ReputationColor:SetVertexColor(unpack(SUI:Color(0.15)))
            end
        end
    end

    --hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", SUIBossFramesText)
    Boss1TargetFrame:HookScript("OnEvent", function(self, event)
        SUIBossFrames(self, event)
    end)

    Boss2TargetFrame:HookScript("OnEvent", function(self, event)
        SUIBossFrames(self, event)
    end)

    Boss3TargetFrame:HookScript("OnEvent", function(self, event)
        SUIBossFrames(self, event)
    end)

    Boss4TargetFrame:HookScript("OnEvent", function(self, event)
        SUIBossFrames(self, event)
    end)

    Boss5TargetFrame:HookScript("OnEvent", function(self, event)
        SUIBossFrames(self, event)
    end)
end
