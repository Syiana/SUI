local Module = SUI:NewModule("CastBars.Target");

local TargetFrameDragFrame = CreateFrame("Frame", "TargetFrameDragFrame", UIParent)
TargetFrameDragFrame:SetPoint("CENTER", MainMenuBar, "CENTER", 0, 200)

function Module:OnEnable()
    local db = {
        style = SUI.db.profile.castbars.style,
        target = SUI.db.profile.castbars.target,
        texture = SUI.db.profile.general.texture
    }
    if (db.style == 'Custom') then
        if not InCombatLockdown() then
            --TargetFrameSpellBar.ignoreFramePositionManager = false
            TargetFrameSpellBar:SetScale(1)
            TargetFrameSpellBar.Icon:SetPoint("RIGHT", TargetFrameSpellBar, "LEFT", -4, 0)
            TargetFrameSpellBar.Icon:SetScale(0.9)
            TargetFrameSpellBar.Border:SetVertexColor(unpack(SUI:Color(0.15)))
            TargetFrameSpellBar.Border:SetDrawLayer("OVERLAY", 1)
            TargetFrameSpellBar:SetWidth(TargetFrameSpellBar:GetWidth()-0.3)
            --Texture
            if (db.texture ~= 'Default') then
                TargetFrameSpellBar:SetStatusBarTexture(db.texture)
            else
                TargetFrameSpellBar:SetStatusBarTexture("Interface\\Addons\\SUI\\Media\\Textures\\Unitframes\\UI-StatusBar")
            end

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
                TargetFrameSpellBar.SetPoint = function() end
            end
        end
    end
end
