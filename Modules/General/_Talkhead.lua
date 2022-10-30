local Module = SUI:NewModule("General.Talkhead");

function Module:OnEnable()
  if not (SUI.db.profile.general.cosmetic.talkhead) then
    hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function() 
      TalkingHeadFrame:Hide()
    end)
  end
end