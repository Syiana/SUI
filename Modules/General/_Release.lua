local Module = SUI:NewModule("General.Release");

function Module:OnEnable()
    local db = {
        release = SUI.db.profile.general.automation.release,
        module = SUI.db.profile.modules.general
    }

    if (db.release and db.module) then
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_DEAD")
        frame:SetScript("OnEvent", function(self, event) RepopMe() end)
    end
end
