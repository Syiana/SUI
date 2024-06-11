local Gryphones = SUI:NewModule("ActionBars.Gryphones");

function Gryphones:OnEnable()
    local db = SUI.db.profile.actionbar

    if (db.gryphones) then
        MainMenuBarLeftEndCap:Show()
        MainMenuBarRightEndCap:Show()
    else
        MainMenuBarLeftEndCap:Hide()
        MainMenuBarRightEndCap:Hide()
    end
end
