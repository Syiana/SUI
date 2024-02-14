local Module = SUI:NewModule("General.Release");

function Module:OnEnable()
    local db = SUI.db.profile.general
    if (db.automation.release) then
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_DEAD")
        frame:SetScript("OnEvent", function(self, event) RepopMe() end)
    end
end
