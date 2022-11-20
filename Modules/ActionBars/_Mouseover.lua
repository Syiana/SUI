local Module = SUI:NewModule("ActionBars.Mouseover");

function Module:OnEnable()
    db = SUI.db.profile.actionbar.bars

    -- Disable GCD Flash if ActionBar is hidden
    hooksecurefunc(getmetatable(ActionButton1Cooldown).__index, 'SetCooldown', function(self)
        if self and self:GetEffectiveAlpha() then
            local alpha = self:GetEffectiveAlpha()
            if alpha > 0.001 then
                self:SetSwipeColor(0,0,0,alpha)
                self:Show()
            else
                self:Hide()
            end
        end
    end)

    if (db.bar1) then
        -- Hide MainMenuBar
        MainMenuBar:SetAlpha(0)

        -- Show MainMenuBar on Hover
        for i=1,12 do
            _G["ActionButton" ..i]:SetScript('OnEnter', function()
                MainMenuBar:SetAlpha(1)
            end)

            _G["ActionButton" ..i]:SetScript('OnLeave', function()
                MainMenuBar:SetAlpha(0)
            end)
        end
    end
    if (db.bar2) then
        -- Hide MultiBarBottomLeft
        MultiBarBottomLeft:SetAlpha(0)

        -- Show MultiBarBottomLeft on Hover
        for i=1,12 do
            _G["MultiBarBottomLeftButton" ..i]:SetScript('OnEnter', function()
                MultiBarBottomLeft:SetAlpha(1)
            end)

            _G["MultiBarBottomLeftButton" ..i]:SetScript('OnLeave', function()
                MultiBarBottomLeft:SetAlpha(0)
            end)
        end
    end
    if (db.bar3) then
        -- Hide MultiBarBottomRight
        MultiBarBottomRight:SetAlpha(0)

        -- Show MultiBarBottomRight on Hover
        for i=1,12 do
            _G["MultiBarBottomRightButton" ..i]:SetScript('OnEnter', function()
                MultiBarBottomRight:SetAlpha(1)
            end)

            _G["MultiBarBottomRightButton" ..i]:SetScript('OnLeave', function()
                MultiBarBottomRight:SetAlpha(0)
            end)
        end
    end
    if (db.bar4) then
        -- Hide MultiBarRight
        MultiBarRight:SetAlpha(0)

        -- Show MultiBarRight on Hover
        for i=1,12 do
            _G["MultiBarRightButton" ..i]:SetScript('OnEnter', function()
                MultiBarRight:SetAlpha(1)
            end)

            _G["MultiBarRightButton" ..i]:SetScript('OnLeave', function()
                MultiBarRight:SetAlpha(0)
            end)
        end
    end
    if (db.bar5) then
        -- Hide MultiBarLeft
        MultiBarLeft:SetAlpha(0)

        -- Show MultiBarLeft on Hover
        for i=1,12 do
            _G["MultiBarLeftButton" ..i]:SetScript('OnEnter', function()
                MultiBarLeft:SetAlpha(1)
            end)

            _G["MultiBarLeftButton" ..i]:SetScript('OnLeave', function()
                MultiBarLeft:SetAlpha(0)
            end)
        end
    end
    if (db.bar6) then
        -- Hide MultiBar5
        MultiBar5:SetAlpha(0)

        -- Show MultiBar5 on Hover
        for i=1,12 do
            _G["MultiBar5Button" ..i]:SetScript('OnEnter', function()
                MultiBar5:SetAlpha(1)
            end)

            _G["MultiBar5Button" ..i]:SetScript('OnLeave', function()
                MultiBar5:SetAlpha(0)
            end)
        end
    end
    if (db.bar7) then
        -- Hide MultiBar6
        MultiBar6:SetAlpha(0)

        -- Show MultiBar6 on Hover
        for i=1,12 do
            _G["MultiBar6Button" ..i]:SetScript('OnEnter', function()
                MultiBar6:SetAlpha(1)
            end)

            _G["MultiBar6Button" ..i]:SetScript('OnLeave', function()
                MultiBar6:SetAlpha(0)
            end)
        end
    end
    if (db.bar8) then
        -- Hide MultiBar7
        MultiBar7:SetAlpha(0)

        -- Show MultiBar7 on Hover
        for i=1,12 do
            _G["MultiBar7Button" ..i]:SetScript('OnEnter', function()
                MultiBar7:SetAlpha(1)
            end)

            _G["MultiBar7Button" ..i]:SetScript('OnLeave', function()
                MultiBar7:SetAlpha(0)
            end)
        end
    end
end