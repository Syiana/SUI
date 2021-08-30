local ADDON, SUI = ...
SUI.MODULES.CASTBARS.Player = function(DB) 
    if (DB and DB.STATE) then
        if not InCombatLockdown() then
            CastingBarFrame.ignoreFramePositionManager = true
            CastingBarFrame:SetMovable(true)
            CastingBarFrame:ClearAllPoints()
            CastingBarFrame:SetScale(1)
            CastingBarFrame:SetUserPlaced(true)
            CastingBarFrame:SetPoint("CENTER", MainMenuBar, "CENTER", 0, 150)
            CastingBarFrame.Icon:Show()
            CastingBarFrame.Icon:ClearAllPoints()
            CastingBarFrame.Icon:SetSize(20, 20)
            CastingBarFrame.Icon:SetPoint("RIGHT", CastingBarFrame, "LEFT", -5, 0)
            CastingBarFrame.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
            CastingBarFrame.Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
            CastingBarFrame.Text:ClearAllPoints()
            CastingBarFrame.Text:SetPoint("CENTER", 0, 1)
            CastingBarFrame.Border:SetWidth(CastingBarFrame.Border:GetWidth() + 4)
            CastingBarFrame.Flash:SetWidth(CastingBarFrame.Flash:GetWidth() + 4)
            CastingBarFrame.BorderShield:SetWidth(CastingBarFrame.BorderShield:GetWidth() + 4)
            CastingBarFrame.Border:SetPoint("TOP", 0, 26)
            CastingBarFrame.Flash:SetPoint("TOP", 0, 26)
            CastingBarFrame.BorderShield:SetPoint("TOP", 0, 26)

            --Texture
            CastingBarFrame:SetStatusBarTexture("Interface\\Addons\\SUI\\Media\\Textures\\Unitframes\\UI-StatusBar")
        end
    end
end