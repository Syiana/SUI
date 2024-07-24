local Menu = SUI:NewModule("ActionBars.Menu");

function Menu:OnEnable()
    if C_AddOns.IsAddOnLoaded('Bartender4') or C_AddOns.IsAddOnLoaded('Dominos') then return end
    local db = {
        micromenu = SUI.db.profile.actionbar.menu.micromenu,
        bagbar = SUI.db.profile.actionbar.menu.bagbar,
        bagPos = SUI.db.profile.edit.bagbar,
        microPos = SUI.db.profile.edit.micromenu,
        menuSize = SUI.db.profile.actionbar.menu.size
    }
end
