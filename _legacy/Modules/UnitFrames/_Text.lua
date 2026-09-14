local Module = SUI:NewModule("UnitFrames.Text");

function Module:RefreshVisibility()
    local enabled = SUI.db.profile.unitframes.hitindicator
    local hitIndicator = PlayerFrame and PlayerFrame.PlayerFrameContent and PlayerFrame.PlayerFrameContent.PlayerFrameContentMain and
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator

    if hitIndicator then
        hitIndicator:SetAlpha(enabled and 1 or 0)
    end
end

function Module:OnEnable()
    local db = SUI.db.profile.unitframes.hitindicator
    if not (db) then
        PlayerFrame:HookScript("OnEvent", function()
            Module:RefreshVisibility()
        end)
        PetHitIndicator:SetText(nil)
        PetHitIndicator.SetText = function() end
    end

    Module:RefreshVisibility()
end
