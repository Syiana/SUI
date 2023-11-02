local Hide = SUI:NewModule("ActionBars.Hide");

function Hide:OnEnable()
    db = SUI.db.profile.misc

    if db.repbar then
        print("test")
        StatusTrackingBarManager:HookScript("OnEvent", function()
            StatusTrackingBarManager:Hide()
        end)
    end
end
