local Module = SUI:NewModule("Misc.Surrender");

function Module:OnEnable()
    local db = SUI.db.profile.misc.surrender
    if (db) then
        function surrender(event, name)
            SLASH_SURRENDERGG1 = "/gg"
            SlashCmdList.SURRENDERGG = SurrenderArena;

            SLASH_SURRENDERSR1 = "/sr"
            SlashCmdList.SURRENDERSR = SurrenderArena;
        end

        local events = CreateFrame("Frame")
        events:RegisterEvent("ADDON_LOADED")
        events:SetScript("OnEvent", surrender)
    end
end
