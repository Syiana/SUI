local Module = SUI:NewModule("General.Talkhead");

function Module:OnEnable()
    if not (SUI.db.profile.general.cosmetic.talkhead) then
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
