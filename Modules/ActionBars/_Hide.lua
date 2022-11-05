local Hide = SUI:NewModule("ActionBars.Hide");

function Hide:OnEnable()
    db = SUI.db.profile.actionbar

    if db.repbar then
        StatusTrackingBarManager:Hide()
    end
end