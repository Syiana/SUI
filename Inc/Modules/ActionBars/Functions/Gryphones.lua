local ADDON, SUI = ...
SUI.MODULES.ACTIONBAR.Gryphones = function(DB) 
    if (DB and DB.STATE) then
        if (DB.CONFIG.Gryphones) then
            MainMenuBarArtFrame.LeftEndCap:Hide()
            MainMenuBarArtFrame.RightEndCap:Hide()
        end
    end
end