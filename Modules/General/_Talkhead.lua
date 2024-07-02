local Module = SUI:NewModule("General.Talkhead");

function Module:OnEnable()
    local db = {
        talkhead = SUI.db.profile.general.cosmetic.talkhead,
        module = SUI.db.profile.modules.general
    }

    if ((not db.talkhead) and db.module) then
        local TalkHead = CreateFrame("Frame")
        TalkHead:RegisterEvent("ADDON_LOADED")
        TalkHead:SetScript("OnEvent", function(self, event, addon)
            if addon == "Blizzard_TalkingHeadUI" then
                hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
                    TalkingHeadFrame_CloseImmediately()
                end)
                self:UnregisterEvent(event)
            end
        end)
    end
end
