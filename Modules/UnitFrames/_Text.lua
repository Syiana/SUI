local Module = SUI:NewModule("UnitFrames.Text");

function Module:OnEnable()
    local db = {
        hitindicator = SUI.db.profile.unitframes.hitindicator,
        module = SUI.db.profile.modules.unitframes
    }

    if ((not db) and db.module) then
        PlayerFrameGroupIndicator:SetAlpha(0)
        PlayerHitIndicator:SetText(nil)
        PlayerHitIndicator.SetText = function() end
        PetHitIndicator:SetText(nil)
        PetHitIndicator.SetText = function() end
    end
end
