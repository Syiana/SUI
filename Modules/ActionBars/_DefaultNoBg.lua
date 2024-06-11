local Module = SUI:NewModule("ActionBars.DefaultNoBg");

function Module:OnEnable()
    local db = SUI.db.profile.actionbar

    if (db.style == 'DefaultNoBg') then
        MainMenuBarArtFrameBackground:Hide()
        MainMenuBarArtFrame.PageNumber:Hide()
        ActionBarUpButton:Hide()
        ActionBarDownButton:Hide()
    end
end
