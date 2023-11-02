local Hide = SUI:NewModule("ActionBars.Hide");

function Hide:OnEnable()
    db = SUI.db.profile.misc

    if db.repbar then
        StatusTrackingBarManager:HookScript("OnEvent", function()
            StatusTrackingBarManager:Hide()
        end)
    end
end
