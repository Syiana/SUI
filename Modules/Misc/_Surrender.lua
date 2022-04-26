local Module = SUI:NewModule("Misc.Surrender");

function Module:OnEnable()
  local db = SUI.db.profile.misc.surrender
  if (db) then
    function core:OnLoadCommandHandler (event, name)
        --on load assign commands
        SLASH_SURRENDERGG1 = "/gg"
        SlashCmdList.SURRENDERGG = SurrenderArena;

        SLASH_SURRENDERSR1 = "/sr"
        SlashCmdList.SURRENDERSR = SurrenderArena;
    end

    local events = CreateFrame("Frame")
    events:RegisterEvent("ADDON_LOADED")
    events:SetScript("OnEvent",core.OnLoadCommandHandler)
  end
end