local Module = SUI:NewModule("General.Talkhead");

function Module:OnEnable()
  local db = SUI.db.profile.general.cosmetic.talkhead
  if (db) then
    if addon == "Blizzard_TalkingHeadUI" then
      hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
        TalkingHeadFrame:Hide()
      end)
      self:UnregisterEvent(event)
    end
  end
end