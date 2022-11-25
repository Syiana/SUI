local Module = SUI:NewModule("ActionBars.Mouseover");

function Module:OnEnable()
    if IsAddOnLoaded('Bartender4') or IsAddOnLoaded('Dominos') then return end
    local db = SUI.db.profile.actionbar.bars

    local function hideGCD(button)
        for i=1,12 do
            if _G[button .. i .. "Cooldown"] then
                _G[button .. i .. "Cooldown"]:SetDrawBling(false)
            end
        end
    end

    local function showGCD(button)
        for i=1,12 do
            if _G[button .. i .. "Cooldown"] then
                _G[button .. i .. "Cooldown"]:SetDrawBling(true)
            end
        end
    end

    if db.bar1 then
        -- Hide MainMenuBar
        MainMenuBar:SetAlpha(0)

        -- Show MainMenuBar on Hover
        for i=1,12 do
            hideGCD("ActionButton")
            _G["ActionButton" ..i]:HookScript('OnEnter', function()
                MainMenuBar:SetAlpha(1)
                showGCD("ActionButton")
            end)

            _G["ActionButton" ..i]:HookScript('OnLeave', function()
                MainMenuBar:SetAlpha(0)
                hideGCD("ActionButton")
            end)
        end
    end

    if db.bar2 then
        -- Hide MultiBarBottomLeft
        MultiBarBottomLeft:SetAlpha(0)

        -- Show MultiBarBottomLeft on Hover
        for i=1,12 do
            hideGCD("MultiBarBottomLeftButton")
            _G["MultiBarBottomLeftButton" ..i]:HookScript('OnEnter', function()
                MultiBarBottomLeft:SetAlpha(1)
                showGCD("MultiBarBottomLeftButton")
            end)

            _G["MultiBarBottomLeftButton" ..i]:HookScript('OnLeave', function()
                MultiBarBottomLeft:SetAlpha(0)
                hideGCD("MultiBarBottomLeftButton")
            end)
        end
    end

    if db.bar3 then
        -- Hide MultiBarBottomRight
        MultiBarBottomRight:SetAlpha(0)

        -- Show MultiBarBottomRight on Hover
        for i=1,12 do
            hideGCD("MultiBarBottomRightButton")
            _G["MultiBarBottomRightButton" ..i]:HookScript('OnEnter', function()
                MultiBarBottomRight:SetAlpha(1)
                showGCD("MultiBarBottomRightButton")
            end)

            _G["MultiBarBottomRightButton" ..i]:HookScript('OnLeave', function()
                MultiBarBottomRight:SetAlpha(0)
                hideGCD("MultiBarBottomRightButton")
            end)
        end
    end

    if db.bar4 then
        -- Hide MultiBarRight
        MultiBarRight:SetAlpha(0)

        -- Show MultiBarRight on Hover
        for i=1,12 do
            hideGCD("MultiBarRightButton")
            _G["MultiBarRightButton" ..i]:HookScript('OnEnter', function(self)
                MultiBarRight:SetAlpha(1)
                showGCD("MultiBarRightButton")
            end)

            _G["MultiBarRightButton" ..i]:HookScript('OnLeave', function()
                MultiBarRight:SetAlpha(0)
                hideGCD("MultiBarRightButton")
            end)
        end
    end

    if db.bar5 then
        -- Hide MultiBarLeft
        MultiBarLeft:SetAlpha(0)

        -- Show MultiBarLeft on Hover
        for i=1,12 do
            hideGCD("MultiBarLeftButton")
            _G["MultiBarLeftButton" ..i]:HookScript('OnEnter', function()
                MultiBarLeft:SetAlpha(1)
                showGCD("MultiBarLeftButton")
            end)

            _G["MultiBarLeftButton" ..i]:HookScript('OnLeave', function()
                MultiBarLeft:SetAlpha(0)
                hideGCD("MultiBarLeftButton")
            end)
        end
    end

    if db.bar6 then
        -- Hide MultiBar5
        MultiBar5:SetAlpha(0)

        -- Show MultiBar5 on Hover
        for i=1,12 do
            hideGCD("MultiBar5Button")
            _G["MultiBar5Button" ..i]:HookScript('OnEnter', function()
                MultiBar5:SetAlpha(1)
                showGCD("MultiBar5Button")
            end)

            _G["MultiBar5Button" ..i]:HookScript('OnLeave', function()
                MultiBar5:SetAlpha(0)
                hideGCD("MultiBar5Button")
            end)
        end
    end

    if db.bar7 then
        -- Hide MultiBar6
        MultiBar6:SetAlpha(0)

        -- Show MultiBar6 on Hover
        for i=1,12 do
            hideGCD("MultiBar6Button")
            _G["MultiBar6Button" ..i]:HookScript('OnEnter', function()
                MultiBar6:SetAlpha(1)
                showGCD("MultiBar6Button")
            end)

            _G["MultiBar6Button" ..i]:HookScript('OnLeave', function()
                MultiBar6:SetAlpha(0)
                hideGCD("MultiBar6Button")
            end)
        end
    end

    if db.bar8 then
        -- Hide MultiBar7
        MultiBar7:SetAlpha(0)

        -- Show MultiBar7 on Hover
        for i=1,12 do
            hideGCD("MultiBar7Button")
            _G["MultiBar7Button" ..i]:HookScript('OnEnter', function()
                MultiBar7:SetAlpha(1)
                showGCD("MultiBar7Button")
            end)

            _G["MultiBar7Button" ..i]:HookScript('OnLeave', function()
                MultiBar7:SetAlpha(0)
                hideGCD("MultiBar7Button")
            end)
        end
    end

    if db.petbar then
        -- Hide Pet Actionbar
        PetActionBar:SetAlpha(0)

        -- Show Pet Actionbar on Hover
        for i=1,10 do
            hideGCD("PetActionButton")
            _G["PetActionButton" .. i]:HookScript('OnEnter', function()
                PetActionBar:SetAlpha(1)
                showGCD("PetActionButton")
            end)

            _G["PetActionButton" .. i]:HookScript('OnLeave', function()
                PetActionBar:SetAlpha(0)
                hideGCD("PetActionButton")
            end)
        end
    end

    if db.stancebar then
        -- Hide Stancebar
        StanceBar:SetAlpha(0)

        -- Show Stancebar on Hover
        for i=1,8 do
            hideGCD("StanceButton")
            _G["StanceButton" .. i]:HookScript('OnEnter', function()
                StanceBar:SetAlpha(1)
                showGCD("StanceButton")
            end)

            _G["StanceButton" .. i]:HookScript('OnLeave', function()
                StanceBar:SetAlpha(0)
                hideGCD("StanceButton")
            end)
        end
    end
end