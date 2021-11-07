local Module = SUI:NewModule("CastBars.Player");

function Module:OnEnable()
  local db = SUI.db.profile.castbars
  if (db.style == 'Custom') then
        if not InCombatLockdown() then
            CastingBarFrame.ignoreFramePositionManager = true
            CastingBarFrame:SetMovable(true)
            CastingBarFrame:ClearAllPoints()
            CastingBarFrame:SetScale(1)
            CastingBarFrame:SetUserPlaced(true)
            CastingBarFrame:SetPoint("CENTER", MainMenuBar, "CENTER", 0, 120)
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