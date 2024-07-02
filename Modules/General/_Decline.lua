local Module = SUI:NewModule("General.Decline");

function Module:OnEnable()
    local db = {
        duel = SUI.db.profile.general.automation.decline,
        module = SUI.db.profile.modules.general
    }

    if (db.duel and db.module) then
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("DUEL_REQUESTED")
        frame:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED")
        frame:SetScript("OnEvent", function(self, event, name)
            if event == "DUEL_REQUESTED" then
                CancelDuel()
                StaticPopup_Hide("DUEL_REQUESTED")
            elseif event == "PET_BATTLE_PVP_DUEL_REQUESTED" then
                C_PetBattles.CancelPVPDuel()
                StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED")
            end
        end)
    end
end
