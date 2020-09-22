local ADDON, SUI = ...
SUI.MODULES.GENERAL.TalkHead = function(state) 
    if (state) then
        if addon == "Blizzard_TalkingHeadUI" then
            hooksecurefunc(
                "TalkingHeadFrame_PlayCurrent",
                function()
                    TalkingHeadFrame:Hide()
                end
            )
            self:UnregisterEvent(event)
        end
    end
end