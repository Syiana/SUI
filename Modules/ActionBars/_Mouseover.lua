local Module = SUI:NewModule("ActionBars.Mouseover");

function Module:OnEnable()
    if IsAddOnLoaded('Bartender4') or IsAddOnLoaded('Dominos') then return end
    MouseoverDefaultBars = LibStub("AceAddon-3.0"):NewAddon("MouseoverDefaultBars", "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceHook-3.0")
    local db = SUI.db.profile.actionbar.bars

    local function hideGCD(button)
        for i = 1, 12 do
            if _G[button .. i .. "Cooldown"] then
                _G[button .. i .. "Cooldown"]:SetDrawBling(false)
            end
        end
    end

    local function showGCD(button)
        for i = 1, 12 do
            if _G[button .. i .. "Cooldown"] then
                _G[button .. i .. "Cooldown"]:SetDrawBling(true)
            end
        end
    end

    local gcd = CreateFrame("Frame")
    gcd:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    gcd:HookScript("OnEvent", function()
        if db.bar1 then
            if MainMenuBar:GetEffectiveAlpha() and MainMenuBar:GetEffectiveAlpha() > 0.001 then
                showGCD("ActionButton")
            else
                hideGCD("ActionButton")
            end
        end

        if db.bar2 then
            if MultiBarBottomLeft:GetEffectiveAlpha() and MultiBarBottomLeft:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBarBottomLeftButton")
            else
                hideGCD("MultiBarBottomLeftButton")
            end
        end

        if db.bar3 then
            if MultiBarBottomRight:GetEffectiveAlpha() and MultiBarBottomRight:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBarBottomRightButton")
            else
                hideGCD("MultiBarBottomRightButton")
            end
        end

        if db.bar4 then
            if MultiBarRight:GetEffectiveAlpha() and MultiBarRight:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBarRightButton")
            else
                hideGCD("MultiBarRightButton")
            end
        end

        if db.bar5 then
            if MultiBarLeft:GetEffectiveAlpha() and MultiBarLeft:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBarLeftButton")
            else
                hideGCD("MultiBarLeftButton")
            end
        end

        if db.bar6 then
            if MultiBar5:GetEffectiveAlpha() and MultiBar5:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBar5Button")
            else
                hideGCD("MultiBar5Button")
            end
        end

        if db.bar7 then
            if MultiBar6:GetEffectiveAlpha() and MultiBar6:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBar6Button")
            else
                hideGCD("MultiBar6Button")
            end
        end

        if db.bar8 then
            if MultiBar7:GetEffectiveAlpha() and MultiBar7:GetEffectiveAlpha() > 0.001 then
                showGCD("MultiBar7Button")
            else
                hideGCD("MultiBar7Button")
            end
        end

        if db.petbar then
            if PetActionBar:GetEffectiveAlpha() and PetActionBar:GetEffectiveAlpha() > 0.001 then
                showGCD("PetActionButton")
            else
                hideGCD("PetActionButton")
            end
        end

        if db.stancebar then
            if StanceBar:GetEffectiveAlpha() and StanceBar:GetEffectiveAlpha() > 0.001 then
                showGCD("StanceButton")
            else
                hideGCD("StanceButton")
            end
        end
    end)

    function MouseoverDefaultBars:OnInitialize()
        MouseoverDefaultBars:loadConfig()
    end

    function MouseoverDefaultBars:loadConfig()
        if db.bar1 then
                MouseoverDefaultBars:onMouseover("bar1")
                MouseoverDefaultBars:Alpha("bar1", 0)
        elseif not db.bar1 then
            MouseoverDefaultBars:Alpha("bar1", 1)
        end
        if db.bar2 then
            MouseoverDefaultBars:onMouseover("bar2")
            MouseoverDefaultBars:Alpha("bar2", 0)
        elseif not db.bar2 then
            MouseoverDefaultBars:Alpha("bar2", 1)
        end
        if db.bar3 then
            MouseoverDefaultBars:onMouseover("bar3")
            MouseoverDefaultBars:Alpha("bar3", 0)
        elseif not db.bar3 then
            MouseoverDefaultBars:Alpha("bar3", 1)
        end
        if db.bar4 then
            MouseoverDefaultBars:onMouseover("bar4")
            MouseoverDefaultBars:Alpha("bar4", 0)
        elseif not db.bar4 then
            MouseoverDefaultBars:Alpha("bar4", 1)
        end
        if db.bar5 then
            MouseoverDefaultBars:onMouseover("bar5")
            MouseoverDefaultBars:Alpha("bar5", 0)
        elseif not db.bar5 then
            MouseoverDefaultBars:Alpha("bar5", 1)
        end
        if db.bar6 then
            MouseoverDefaultBars:onMouseover("bar6")
            MouseoverDefaultBars:Alpha("bar6", 0)
        elseif not db.bar6 then
            MouseoverDefaultBars:Alpha("bar6", 1)
        end
        if db.bar7 then
            MouseoverDefaultBars:onMouseover("bar7")
            MouseoverDefaultBars:Alpha("bar7", 0)
        elseif not db.bar7 then
            MouseoverDefaultBars:Alpha("bar7", 1)
        end
        if db.bar8 then
            MouseoverDefaultBars:onMouseover("bar8")
            MouseoverDefaultBars:Alpha("bar8", 0)
        elseif not db.bar8 then
            MouseoverDefaultBars:Alpha("bar8", 1)
        end
        if db.petbar then
            MouseoverDefaultBars:onMouseover("petbar")
            MouseoverDefaultBars:Alpha("petbar", 0)
        elseif not db.petbar then
            MouseoverDefaultBars:Alpha("petbar", 1)
        end
        if db.stancebar then
            MouseoverDefaultBars:onMouseover("stancebar")
            MouseoverDefaultBars:Alpha("stancebar", 0)
        elseif not db.stancebar then
            MouseoverDefaultBars:Alpha("stancebar", 1)
        end
    end

    function MouseoverDefaultBars:Alpha(actionbar, alpha)
        if actionbar == "bar1" then
            for i=1,12 do
                _G["ActionButton" ..i]:SetAlpha(alpha)
            end
        elseif actionbar == "bar2" then
            MultiBarBottomLeft:SetAlpha(alpha)
        elseif actionbar == "bar3" then
            MultiBarBottomRight:SetAlpha(alpha)
        elseif actionbar == "bar4" then
            MultiBarRight:SetAlpha(alpha)
        elseif actionbar == "bar5" then
            MultiBarLeft:SetAlpha(alpha)
        elseif actionbar == "bar6" then
            MultiBar5:SetAlpha(alpha)
        elseif actionbar == "bar7" then
            MultiBar6:SetAlpha(alpha)
        elseif actionbar == "bar8" then
            MultiBar7:SetAlpha(alpha)
        elseif actionbar == "petbar" then
            PetActionBar:SetAlpha(alpha)
        elseif actionbar == "stancebar" then
            StanceBar:SetAlpha(alpha)
        end
    end

    local ABtimer1

    function MouseoverDefaultBars:onMouseover(actionbar)
    if actionbar == "bar1" then
        for i=1,12 do 
            if not MouseoverDefaultBars:IsHooked(_G["ActionButton" ..i], "OnEnter") then
                MouseoverDefaultBars:SecureHookScript(_G["ActionButton" ..i], "OnEnter", function () MouseoverDefaultBars:CancelTimer(ABtimer1); MouseoverDefaultBars:Alpha(actionbar, 1) end)
            end
            if not MouseoverDefaultBars:IsHooked(_G["ActionButton" ..i], "OnLeave") then
             MouseoverDefaultBars:SecureHookScript(_G["ActionButton" ..i], "OnLeave", function () ABtimer1 = MouseoverDefaultBars:ScheduleTimer(function () MouseoverDefaultBars:Alpha(actionbar, 0)end, 0.1)end)
            end      
        end
    elseif actionbar == "bar2" then
        local ABtimer2
        for i =1,12 do
            if not MouseoverDefaultBars:IsHooked(_G["MultiBarBottomLeftButton" ..i], "OnEnter") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBarBottomLeftButton" ..i], "OnEnter", function() MouseoverDefaultBars:CancelTimer(ABtimer2); MouseoverDefaultBars:Alpha(actionbar, 1) end)
            end
            if not MouseoverDefaultBars:IsHooked(_G["MultiBarBottomLeftButton" ..i], "OnLeave") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBarBottomLeftButton" ..i], "OnLeave", function () ABtimer2 = MouseoverDefaultBars:ScheduleTimer(function () MouseoverDefaultBars:Alpha(actionbar, 0)end, 0.1)end)
            end
        end
    elseif actionbar == "bar3" then
        local ABtimer3
        for i = 1,12 do
            if not MouseoverDefaultBars:IsHooked(_G["MultiBarBottomRightButton" ..i], "OnEnter") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBarBottomRightButton" ..i], "OnEnter", function() MouseoverDefaultBars:CancelTimer(ABtimer3); MouseoverDefaultBars:Alpha(actionbar, 1) end)
            end
            if not MouseoverDefaultBars:IsHooked(_G["MultiBarBottomRightButton" ..i], "OnLeave") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBarBottomRightButton" ..i], "OnLeave", function () ABtimer3 = MouseoverDefaultBars:ScheduleTimer(function () MouseoverDefaultBars:Alpha(actionbar, 0)end)end)
            end
        end
    elseif actionbar == "bar4" then
        local ABtimer4
        for i = 1,12 do
            if not MouseoverDefaultBars:IsHooked(_G["MultiBarRightButton" ..i], "OnEnter") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBarRightButton" ..i], "OnEnter", function() MouseoverDefaultBars:CancelTimer(ABtimer4); MouseoverDefaultBars:Alpha(actionbar, 1) end)
            end
            if not MouseoverDefaultBars:IsHooked(_G["MultiBarRightButton" ..i], "OnLeave") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBarRightButton" ..i], "OnLeave", function () ABtimer4 = MouseoverDefaultBars:ScheduleTimer(function () MouseoverDefaultBars:Alpha(actionbar, 0)end, 0.1)end)
            end
        end
    elseif actionbar == "bar5" then
        local ABtimer5
        for i = 1,12 do
            if not MouseoverDefaultBars:IsHooked(_G["MultiBarLeftButton" ..i], "OnEnter") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBarLeftButton" ..i], "OnEnter", function() MouseoverDefaultBars:CancelTimer(ABtimer5); MouseoverDefaultBars:Alpha(actionbar, 1) end)
            end
            if not MouseoverDefaultBars:IsHooked(_G["MultiBarLeftButton" ..i], "OnLeave") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBarLeftButton" ..i], "OnLeave", function () ABtimer5 = MouseoverDefaultBars:ScheduleTimer(function () MouseoverDefaultBars:Alpha(actionbar, 0)end, 0.1)end)
            end
        end
    elseif actionbar == "bar6" then
        local ABtimer6
        for i = 1,12 do
            if not MouseoverDefaultBars:IsHooked(_G["MultiBar5Button" ..i], "OnEnter") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBar5Button" ..i], "OnEnter", function() MouseoverDefaultBars:CancelTimer(ABtimer6); MouseoverDefaultBars:Alpha(actionbar, 1) end)
            end
            if not MouseoverDefaultBars:IsHooked(_G["MultiBar5Button" ..i], "OnLeave") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBar5Button" ..i], "OnLeave", function () ABtimer6 = MouseoverDefaultBars:ScheduleTimer(function () MouseoverDefaultBars:Alpha(actionbar, 0)end, 0.1)end)
            end
        end
    elseif actionbar == "bar7" then
        local ABtimer7
        for i = 1,12 do
            if not MouseoverDefaultBars:IsHooked(_G["MultiBar6Button" ..i], "OnEnter") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBar6Button" ..i], "OnEnter", function() MouseoverDefaultBars:CancelTimer(ABtimer7); MouseoverDefaultBars:Alpha(actionbar, 1) end)
            end
            if not MouseoverDefaultBars:IsHooked(_G["MultiBar6Button" ..i], "OnLeave") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBar6Button" ..i], "OnLeave", function () ABtimer7 = MouseoverDefaultBars:ScheduleTimer(function () MouseoverDefaultBars:Alpha(actionbar, 0)end, 0.1)end)
            end
        end
    elseif actionbar == "bar8" then
        local ABtimer8
        for i = 1,12 do
            if not MouseoverDefaultBars:IsHooked(_G["MultiBar7Button" ..i], "OnEnter") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBar7Button" ..i], "OnEnter", function() MouseoverDefaultBars:CancelTimer(ABtimer8); MouseoverDefaultBars:Alpha(actionbar, 1) end)
            end
            if not MouseoverDefaultBars:IsHooked(_G["MultiBar7Button" ..i], "OnLeave") then
                MouseoverDefaultBars:SecureHookScript(_G["MultiBar7Button" ..i], "OnLeave", function () ABtimer8 = MouseoverDefaultBars:ScheduleTimer(function () MouseoverDefaultBars:Alpha(actionbar, 0)end, 0.1)end)
            end
        end
    elseif actionbar == "petbar" then --pet bar
        local ABtimer9
        for i = 1,10 do
            if not MouseoverDefaultBars:IsHooked(_G["PetActionButton" ..i], "OnEnter") then
                MouseoverDefaultBars:SecureHookScript(_G["PetActionButton" ..i], "OnEnter", function() MouseoverDefaultBars:CancelTimer(ABtimer9); MouseoverDefaultBars:Alpha(actionbar, 1) end)
            end
            if not MouseoverDefaultBars:IsHooked(_G["PetActionButton" ..i], "OnLeave") then
                MouseoverDefaultBars:SecureHookScript(_G["PetActionButton" ..i], "OnLeave", function () ABtimer9 = MouseoverDefaultBars:ScheduleTimer(function () MouseoverDefaultBars:Alpha(actionbar, 0)end, 0.1)end)
            end
        end
    elseif actionbar == "stancebar" then --stance bar
        local ABtimer10
        for i = 1,10 do
            if not MouseoverDefaultBars:IsHooked(_G["StanceButton" ..i], "OnEnter") then
                MouseoverDefaultBars:SecureHookScript(_G["StanceButton" ..i], "OnEnter", function() MouseoverDefaultBars:CancelTimer(ABtimer10); MouseoverDefaultBars:Alpha(actionbar, 1) end)
            end
            if not MouseoverDefaultBars:IsHooked(_G["StanceButton" ..i], "OnLeave") then
                MouseoverDefaultBars:SecureHookScript(_G["StanceButton" ..i], "OnLeave", function() ABtimer10 = MouseoverDefaultBars:ScheduleTimer(function () MouseoverDefaultBars:Alpha(actionbar, 0)end, 0.1)end)
            end
        end
    end
    end

    function MouseoverDefaultBars:ShowGrid()
        MouseoverDefaultBars:CancelAllTimers() 
        MouseoverDefaultBars:UnhookAll()
        for i = 1,10 do
            MouseoverDefaultBars:Alpha("ActionBar"..i, 1)
        end  
    end

    function MouseoverDefaultBars:HideGrid()
        if not KeybindFrames_InQuickKeybindMode() then
            MouseoverDefaultBars:loadConfig()
        end
    end

    MouseoverDefaultBars:RegisterEvent("ACTIONBAR_SHOWGRID", "ShowGrid")
    MouseoverDefaultBars:RegisterEvent("ACTIONBAR_HIDEGRID", "HideGrid")
    MouseoverDefaultBars:RegisterEvent("PLAYER_ENTERING_WORLD","loadConfig")
end
