local Buttons = SUI:NewModule("ActionBars.Flash");
local hooksInstalled
local animations
local animationNum = 1

local function isFlashEnabled()
    return SUI.db and SUI.db.profile and SUI.db.profile.actionbar and SUI.db.profile.actionbar.buttons and
        SUI.db.profile.actionbar.buttons.flash
end

local function ensureAnimations()
    if animations then
        return
    end

    local animationsCount = 5
    animations = {}

    for i = 1, animationsCount do
        local frame = CreateFrame("Frame")
        local texture = frame:CreateTexture()
        texture:SetTexture('Interface\\Cooldown\\star4')
        texture:SetAlpha(0)
        texture:SetAllPoints()
        texture:SetBlendMode("ADD")

        local animationGroup = texture:CreateAnimationGroup()
        local alpha1 = animationGroup:CreateAnimation("Alpha")
        alpha1:SetFromAlpha(0)
        alpha1:SetToAlpha(1)
        alpha1:SetDuration(0)
        alpha1:SetOrder(1)

        local scale1 = animationGroup:CreateAnimation("Scale")
        scale1:SetScale(1.0, 1.0)
        scale1:SetDuration(0)
        scale1:SetOrder(1)

        local scale2 = animationGroup:CreateAnimation("Scale")
        scale2:SetScale(1.5, 1.5)
        scale2:SetDuration(0.3)
        scale2:SetOrder(2)

        local rotation2 = animationGroup:CreateAnimation("Rotation")
        rotation2:SetDegrees(90)
        rotation2:SetDuration(0.3)
        rotation2:SetOrder(2)

        animations[i] = { frame = frame, animationGroup = animationGroup }
    end
end

local function animateButton(self)
    if not isFlashEnabled() or not self or not self:IsVisible() then
        return true
    end

    local animation = animations[animationNum]
    local frame = animation.frame
    local animationGroup = animation.animationGroup
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(20)
    frame:SetAllPoints(self)
    animationGroup:Stop()
    animationGroup:Play()
    animationNum = (animationNum % #animations) + 1
    return true
end

function Buttons:OnEnable()
    if hooksInstalled then
        return
    end

    ensureAnimations()

    hooksecurefunc('MultiActionButtonDown', function(bname, id)
        if not isFlashEnabled() or not _G[bname] or _G[bname]:GetEffectiveAlpha() ~= 1 then
            return
        end

        animateButton(_G[bname .. 'Button' .. id])
    end)

    hooksecurefunc(PetActionBar, 'PetActionButtonDown', function(_, id)
        if not isFlashEnabled() or not PetActionBar then
            return
        end

        if id > NUM_PET_ACTION_SLOTS then
            return
        end

        local button = _G["PetActionButton" .. id]
        if not button then
            return
        end

        return animateButton(button)
    end)

    hooksecurefunc('ActionButtonDown', function(id)
        if not isFlashEnabled() then
            return
        end

        local button
        if C_PetBattles.IsInBattle() then
            if PetBattleFrame then
                if id > NUM_BATTLE_PET_HOTKEYS then
                    return
                end

                button = PetBattleFrame.BottomFrame.abilityButtons[id]
                if id == BATTLE_PET_ABILITY_SWITCH then
                    button = PetBattleFrame.BottomFrame.SwitchPetButton
                elseif id == BATTLE_PET_ABILITY_CATCH then
                    button = PetBattleFrame.BottomFrame.CatchButton
                end
            end
            return
        end

        if not C_AddOns.IsAddOnLoaded("Bartender4") then
            if OverrideActionBar and OverrideActionBar:IsShown() then
                if id > NUM_OVERRIDE_BUTTONS then
                    return
                end
                button = _G["OverrideActionBarButton" .. id]
            else
                button = _G["ActionButton" .. id]
            end
        end

        if not button or button:GetEffectiveAlpha() ~= 1 then
            return
        end

        animateButton(button)
    end)

    hooksInstalled = true
end
