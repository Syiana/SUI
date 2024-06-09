local Buttons = SUI:NewModule("ActionBars.Flash");

function Buttons:OnEnable()
    local db = SUI.db.profile.actionbar.buttons

    if (db.flash) then
        local animationsCount, animations = 5, {}
        local animationNum = 1
        local frame, texture, alpha1, scale1, scale2, rotation2
        for i = 1, animationsCount do
            frame = CreateFrame("Frame")
            texture = frame:CreateTexture()
            texture:SetTexture('Interface\\Cooldown\\star4')
            texture:SetAlpha(0)
            texture:SetAllPoints()
            texture:SetBlendMode("ADD")
            animationGroup = texture:CreateAnimationGroup()
            alpha1 = animationGroup:CreateAnimation("Alpha")
            alpha1:SetFromAlpha(0)
            alpha1:SetToAlpha(1)
            alpha1:SetDuration(0)
            alpha1:SetOrder(1)
            scale1 = animationGroup:CreateAnimation("Scale")
            scale1:SetScale(1.0, 1.0)
            scale1:SetDuration(0)
            scale1:SetOrder(1)
            scale2 = animationGroup:CreateAnimation("Scale")
            scale2:SetScale(1.5, 1.5)
            scale2:SetDuration(0.3)
            scale2:SetOrder(2)
            rotation2 = animationGroup:CreateAnimation("Rotation")
            rotation2:SetDegrees(90)
            rotation2:SetDuration(0.3)
            rotation2:SetOrder(2)
            animations[i] = { frame = frame, animationGroup = animationGroup }
        end
        local AnimateButton = function(self)
            if not self:IsVisible() then return true end
            local animation = animations[animationNum]
            local frame = animation.frame
            local animationGroup = animation.animationGroup
            frame:SetFrameStrata("HIGH")
            frame:SetFrameLevel(20)
            frame:SetAllPoints(self)
            animationGroup:Stop()
            animationGroup:Play()
            animationNum = (animationNum % animationsCount) + 1
            return true
        end

        hooksecurefunc('MultiActionButtonDown', function(bname, id)
            if _G[bname]:GetEffectiveAlpha() == 1 then
                AnimateButton(_G[bname .. 'Button' .. id])
            end
        end)

        hooksecurefunc(PetActionBar, 'PetActionButtonDown', function(self, id)
            local button
            if PetActionBar then
                if id > NUM_PET_ACTION_SLOTS then return end
                button = _G["PetActionButton"..id]
                if not button then return end
            end
            return AnimateButton(button)
        end)

        hooksecurefunc('ActionButtonDown', function(id)
            local button
            if C_PetBattles.IsInBattle() then
                if PetBattleFrame then
                    if id > NUM_BATTLE_PET_HOTKEYS then return end
                    button = PetBattleFrame.BottomFrame.abilityButtons[id]
                    if id == BATTLE_PET_ABILITY_SWITCH then
                        button = PetBattleFrame.BottomFrame.SwitchPetButton;
                    elseif id == BATTLE_PET_ABILITY_CATCH then
                        button = PetBattleFrame.BottomFrame.CatchButton;
                    end
                    if not button then return end
                end
                return
            end
            if (C_AddOns.IsAddOnLoaded("Bartender4")) then

            else
                if OverrideActionBar and OverrideActionBar:IsShown() then
                    if id > NUM_OVERRIDE_BUTTONS then return end
                    button = _G["OverrideActionBarButton" .. id]
                else
                    button = _G["ActionButton" .. id]
                end
            end
            if not button then return end
            if button:GetEffectiveAlpha() == 1 then
                AnimateButton(button)
            end
        end)
    end

end
