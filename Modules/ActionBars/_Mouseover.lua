local Module = SUI:NewModule("ActionBars.Mouseover");

function Module:OnEnable()
    if IsAddOnLoaded('Bartender4') or IsAddOnLoaded('Dominos') then return end
    local db = SUI.db.profile.actionbar.bars

    hooksecurefunc(getmetatable(CreateFrame('cooldown')).__index, 'SetCooldown', function(self)
        if self and self:GetEffectiveAlpha() then
            if self:GetEffectiveAlpha() > 0.001 then
                self:SetDrawBling(true)
            else
                self:SetDrawBling(false)
            end
        end
    end)

    if db.bar1 then
        -- Hide MainMenuBar
        MainMenuBar:SetAlpha(0)

        -- Show MainMenuBar on Hover
        for i=1,12 do
            if _G["ActionButton" ..i]:GetEffectiveAlpha() then
                if _G["ActionButton" ..i] > 0.001 then
                    _G["ActionButton" ..i]:SetDrawBling(true)
                else
                    _G["ActionButton" ..i]:SetDrawBling(false)
                end
            end
            _G["ActionButton" ..i]:HookScript('OnEnter', function()
                MainMenuBar:SetAlpha(1)
            end)

            _G["ActionButton" ..i]:HookScript('OnLeave', function()
                MainMenuBar:SetAlpha(0)
            end)
        end
    end

    if db.bar2 then
        -- Hide MultiBarBottomLeft
        MultiBarBottomLeft:SetAlpha(0)

        -- Show MultiBarBottomLeft on Hover
        for i=1,12 do
            _G["MultiBarBottomLeftButton" ..i]:HookScript('OnEnter', function()
                MultiBarBottomLeft:SetAlpha(1)
            end)

            _G["MultiBarBottomLeftButton" ..i]:HookScript('OnLeave', function()
                MultiBarBottomLeft:SetAlpha(0)
            end)
        end
    end

    if db.bar3 then
        -- Hide MultiBarBottomRight
        MultiBarBottomRight:SetAlpha(0)

        -- Show MultiBarBottomRight on Hover
        for i=1,12 do
            _G["MultiBarBottomRightButton" ..i]:HookScript('OnEnter', function()
                MultiBarBottomRight:SetAlpha(1)
            end)

            _G["MultiBarBottomRightButton" ..i]:HookScript('OnLeave', function()
                MultiBarBottomRight:SetAlpha(0)
            end)
        end
    end

    if db.bar4 then
        -- Hide MultiBarRight
        MultiBarRight:SetAlpha(0)

        -- Show MultiBarRight on Hover
        for i=1,12 do
            _G["MultiBarRightButton" ..i]:HookScript('OnEnter', function(self)
                MultiBarRight:SetAlpha(1)
            end)

            _G["MultiBarRightButton" ..i]:HookScript('OnLeave', function()
                MultiBarRight:SetAlpha(0)
            end)
        end
    end

    if db.bar5 then
        -- Hide MultiBarLeft
        MultiBarLeft:SetAlpha(0)

        -- Show MultiBarLeft on Hover
        for i=1,12 do
            _G["MultiBarLeftButton" ..i]:HookScript('OnEnter', function()
                MultiBarLeft:SetAlpha(1)
            end)

            _G["MultiBarLeftButton" ..i]:HookScript('OnLeave', function()
                MultiBarLeft:SetAlpha(0)
            end)
        end
    end

    if db.bar6 then
        -- Hide MultiBar5
        MultiBar5:SetAlpha(0)

        -- Show MultiBar5 on Hover
        for i=1,12 do
            _G["MultiBar5Button" ..i]:HookScript('OnEnter', function()
                MultiBar5:SetAlpha(1)
            end)

            _G["MultiBar5Button" ..i]:HookScript('OnLeave', function()
                MultiBar5:SetAlpha(0)
            end)
        end
    end

    if db.bar7 then
        -- Hide MultiBar6
        MultiBar6:SetAlpha(0)

        -- Show MultiBar6 on Hover
        for i=1,12 do
            _G["MultiBar6Button" ..i]:HookScript('OnEnter', function()
                MultiBar6:SetAlpha(1)
            end)

            _G["MultiBar6Button" ..i]:HookScript('OnLeave', function()
                MultiBar6:SetAlpha(0)
            end)
        end
    end

    if db.bar8 then
        -- Hide MultiBar7
        MultiBar7:SetAlpha(0)

        -- Show MultiBar7 on Hover
        for i=1,12 do
            _G["MultiBar7Button" ..i]:HookScript('OnEnter', function()
                MultiBar7:SetAlpha(1)
            end)

            _G["MultiBar7Button" ..i]:HookScript('OnLeave', function()
                MultiBar7:SetAlpha(0)
            end)
        end
    end

    if db.petbar then
        -- Hide Pet Actionbar
        PetActionBar:SetAlpha(0)

        -- Show Pet Actionbar on Hover
        for i=1,10 do
            _G["PetActionButton" .. i]:HookScript('OnEnter', function()
                PetActionBar:SetAlpha(1)
            end)

            _G["PetActionButton" .. i]:HookScript('OnLeave', function()
                PetActionBar:SetAlpha(0)
            end)
        end
    end

    if db.stancebar then
        -- Hide Stancebar
        StanceBar:SetAlpha(0)

        -- Show Stancebar on Hover
        for i=1,8 do
            _G["StanceButton" .. i]:HookScript('OnEnter', function()
                StanceBar:SetAlpha(1)
            end)

            _G["StanceButton" .. i]:HookScript('OnLeave', function()
                StanceBar:SetAlpha(0)
            end)
        end
    end
end