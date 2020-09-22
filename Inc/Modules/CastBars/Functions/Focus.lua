local ADDON, SUI = ...
SUI.MODULES.CASTBARS.Focus = function(DB) 
    if (DB and DB.STATE) then
        if not InCombatLockdown() then
            FocusFrameSpellBar:SetStatusBarTexture("Interface\\Addons\\SUI\\Inc\\Assets\\Media\\Unitframes\\UI-StatusBar")
        end
    end
end