local Module = SUI:NewModule("CastBars.Target");

local TargetFrameDragFrame = CreateFrame("Frame", "TargetFrameDragFrame", UIParent)
TargetFrameDragFrame:SetPoint("CENTER", MainMenuBar, "CENTER", 0, 200)

function Module:OnEnable()
  local db = SUI.db.profile.castbars
    if (db.style == 'Custom') then
        if not InCombatLockdown() then
          TargetFrameSpellBar.ignoreFramePositionManager = true
          TargetFrameSpellBar:SetMovable(true)
          TargetFrameSpellBar:ClearAllPoints()
          TargetFrameSpellBar:SetScale(1.32)
          TargetFrameSpellBar:SetPoint("CENTER", TargetFrameDragFrame)
          TargetFrameSpellBar:SetUserPlaced(false)
          TargetFrameSpellBar:SetMovable(false)
          TargetFrameSpellBar.Icon:SetPoint("RIGHT", TargetFrameSpellBar, "LEFT", -3, 0)
          TargetFrameSpellBar.SetPoint = function()end
          TargetFrameSpellBar:SetStatusBarColor(1, 0, 0)
          TargetFrameSpellBar.SetStatusBarColor = function()end
          TargetFrameDragFrame:SetWidth(CastingBarFrame:GetWidth())
          TargetFrameDragFrame:SetHeight(CastingBarFrame:GetHeight())
          --Texture
          TargetFrameSpellBar:SetStatusBarTexture("Interface\\Addons\\SUI\\Media\\Textures\\Unitframes\\UI-StatusBar")
        end
    end
end