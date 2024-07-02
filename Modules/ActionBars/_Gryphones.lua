local Gryphones = SUI:NewModule("ActionBars.Gryphones");

function Gryphones:OnEnable()
    local db = {
        gryphones = SUI.db.profile.actionbar.gryphones,
        module = SUI.db.profile.modules.actionbar
    }

    if ((not db.gryphones) and db.module) then
        MainMenuBarLeftEndCap:Hide()
        MainMenuBarRightEndCap:Hide()
    else
        MainMenuBarLeftEndCap:Show()
        MainMenuBarRightEndCap:Show()
    end
end
