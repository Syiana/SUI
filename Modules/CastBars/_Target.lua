local Module = SUI:NewModule("CastBars.Target");

local TargetFrameDragFrame = CreateFrame("Frame", "TargetFrameDragFrame", UIParent)
TargetFrameDragFrame:SetPoint("CENTER", MainMenuBar, "CENTER", 0, 200)

function Module:OnEnable()
    local db = SUI.db.profile.castbars
    if (db.style == 'Custom') then
        if not InCombatLockdown() then
            TargetFrameSpellBar.ignoreFramePositionManager = false
            TargetFrameSpellBar:SetScale(1)
            TargetFrameSpellBar.Icon:SetPoint("RIGHT", TargetFrameSpellBar, "LEFT", -4, 0)
            TargetFrameSpellBar.Icon:SetScale(0.9)
            TargetFrameSpellBar.SetPoint = function() end
            TargetFrameSpellBar:SetStatusBarColor(1, 0, 0)
            TargetFrameSpellBar.SetStatusBarColor = function() end
            TargetFrameSpellBar.Border:SetVertexColor(unpack(SUI:Color(0.15)))
            TargetFrameSpellBar.Border:SetDrawLayer("OVERLAY", 1)
            --Texture
            TargetFrameSpellBar:SetStatusBarTexture("Interface\\Addons\\SUI\\Media\\Textures\\Unitframes\\UI-StatusBar")

            if (db.target) then
                TargetFrameSpellBar.ignoreFramePositionManager = true
                TargetFrameSpellBar:SetMovable(true)
                TargetFrameSpellBar:ClearAllPoints()
                TargetFrameSpellBar:SetPoint("CENTER", TargetFrameDragFrame)
                TargetFrameSpellBar:SetUserPlaced(false)
                TargetFrameDragFrame:SetWidth(CastingBarFrame:GetWidth())
                TargetFrameDragFrame:SetHeight(CastingBarFrame:GetHeight())
                TargetFrameSpellBar:SetMovable(false)
                TargetFrameSpellBar:SetScale(1.3)
            end
        end
    end
end
