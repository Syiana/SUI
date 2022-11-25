local Module = SUI:NewModule("ActionBars.Mouseover");

function Module:OnEnable()
    if IsAddOnLoaded('Bartender4') or IsAddOnLoaded('Dominos') then return end
    local db = SUI.db.profile.actionbar.bars

    local gcd = CreateFrame("Frame")
    gcd:RegisterEvent("SPELL_UPDATE_COOLDOWN")

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
        gcd:HookScript("OnEvent", function()
            if MainMenuBar:GetEffectiveAlpha() and MainMenuBar:GetEffectiveAlpha() > 0.001 then
                showGCD("ActionButton")
            else
                hideGCD("ActionButton")
            end
        end)

        -- Show MainMenuBar on Hover
        for i=1,12 do
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
        gcd:HookScript("OnEvent", function()
            if MultiBarBottomLeft:GetEffectiveAlpha() and MultiBarBottomLeft:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBarBottomLeftButton")
            else
                hideGCD("MultiBarBottomLeftButton")
            end
        end)

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
        gcd:HookScript("OnEvent", function()
            if MultiBarBottomRight:GetEffectiveAlpha() and MultiBarBottomRight:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBarBottomRightButton")
            else
                hideGCD("MultiBarBottomRightButton")
            end
        end)

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

        gcd:HookScript("OnEvent", function()
            if MultiBarRight:GetEffectiveAlpha() and MultiBarRight:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBarRightButton")
            else
                hideGCD("MultiBarRightButton")
            end
        end)

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
        gcd:HookScript("OnEvent", function()
            if MultiBarLeft:GetEffectiveAlpha() and MultiBarLeft:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBarLeftButton")
            else
                hideGCD("MultiBarLeftButton")
            end
        end)

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
        gcd:HookScript("OnEvent", function()
            if MultiBar5:GetEffectiveAlpha() and MultiBar5:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBar5Button")
            else
                hideGCD("MultiBar5Button")
            end
        end)

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
        gcd:HookScript("OnEvent", function()
            if MultiBar6:GetEffectiveAlpha() and MultiBar6:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBar6Button")
            else
                hideGCD("MultiBar6Button")
            end
        end)

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
        gcd:HookScript("OnEvent", function()
            if MultiBar7:GetEffectiveAlpha() and MultiBar7:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBar7Button")
            else
                hideGCD("MultiBar7Button")
            end
        end)

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
        gcd:HookScript("OnEvent", function()
            if PetActionBar:GetEffectiveAlpha() and PetActionBar:GetEffectiveAlpha() > 0.001 then
                showGCD("PetActionButton")
            else
                hideGCD("PetActionButton")
            end
        end)

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
        gcd:HookScript("OnEvent", function()
            if StanceBar:GetEffectiveAlpha() and StanceBar:GetEffectiveAlpha() > 0.001 then
                showGCD("StanceButton")
            else
                hideGCD("StanceButton")
            end
        end)

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