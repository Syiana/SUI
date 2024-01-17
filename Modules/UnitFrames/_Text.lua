local Module = SUI:NewModule("UnitFrames.Text");

function Module:OnEnable()
    local db = SUI.db.profile.unitframes.hitindicator
    if not (db) then
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText:SetText(nil)
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText = function() end
        PetHitIndicator:SetText(nil)
        PetHitIndicator.SetText = function() end
    end
end
