local Module = SUI:NewModule("General.Talkhead");

function Module:OnEnable()
  if not (SUI.db.profile.general.cosmetic.talkhead) then
    if addon == "Blizzard_TalkingHeadUI" then
      hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
        TalkingHeadFrame:Hide()
      end)
      self:UnregisterEvent(event)
    end
  end
end