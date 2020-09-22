local ADDON, SUI = ...
SUI.MODULES.CASTBARS.Target = function(DB) 
    if (DB and DB.STATE) then
        if not InCombatLockdown() then
            TargetFrameSpellBar.ignoreFramePositionManager = true
            TargetFrameSpellBar:SetMovable(true)
            TargetFrameSpellBar:ClearAllPoints()
            TargetFrameSpellBar:SetScale(1.3)
            TargetFrameSpellBar:SetPoint("CENTER", MainMenuBar, "CENTER", 0, 150)
            TargetFrameSpellBar:SetUserPlaced(false)
            TargetFrameSpellBar:SetMovable(false)
            TargetFrameSpellBar.Icon:SetPoint("RIGHT", TargetFrameSpellBar, "LEFT", -3, 0)
            TargetFrameSpellBar.SetPoint = function()end
            TargetFrameSpellBar:SetStatusBarColor(1, 0, 0)
            TargetFrameSpellBar.SetStatusBarColor = function()end

            --Texture
            TargetFrameSpellBar:SetStatusBarTexture("Interface\\Addons\\SUI\\Inc\\Assets\\Media\\Unitframes\\UI-StatusBar")
        end
    end
end