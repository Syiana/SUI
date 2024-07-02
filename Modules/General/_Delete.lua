local Module = SUI:NewModule("General.Delete");

function Module:OnEnable()
    local db = {
        delete = SUI.db.profile.general.automation.delete,
        module = SUI.db.profile.modules.general
    }

    if (db.delete and db.module) then
        hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"], "OnShow", function(s)
            s.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
        end)
    end
end
