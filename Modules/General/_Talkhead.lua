local Module = SUI:NewModule("General.Talkhead");

function Module:OnEnable()
    local db = SUI.db.profile.general.cosmetic.talkinghead
    if not db then
        hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function()
            TalkingHeadFrame:Hide()
        end)
    end
end