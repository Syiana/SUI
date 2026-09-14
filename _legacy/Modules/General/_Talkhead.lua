local Module = SUI:NewModule("General.Talkhead");

function Module:OnEnable()
    local cosmetic = SUI.db.profile.general.cosmetic
    local db = cosmetic.talkhead
    if cosmetic.talkinghead ~= nil then
        db = cosmetic.talkinghead
    end

    if not db then
        hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function()
            TalkingHeadFrame:Hide()
        end)
    end
end
