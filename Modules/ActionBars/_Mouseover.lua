local Module = SUI:NewModule("ActionBars.Mouseover");

function Module:OnEnable()
    MouseoverDefaultBars = LibStub("AceAddon-3.0"):NewAddon("MouseoverDefaultBars", "AceConsole-3.0", "AceTimer-3.0",
        "AceEvent-3.0", "AceHook-3.0")
    local db = SUI.db.profile.actionbar.mouseover

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

        if db.stancebar then
            if not SUIStanceBar then return end
            if SUIStanceBar:GetEffectiveAlpha() and SUIStanceBar:GetEffectiveAlpha() > 0.001 then
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
        if db.stancebar then
            MouseoverDefaultBars:onMouseover("stancebar")
            MouseoverDefaultBars:Alpha("stancebar", 0)
        elseif not db.stancebar then
            MouseoverDefaultBars:Alpha("stancebar", 1)
        end
    end

    function MouseoverDefaultBars:Alpha(actionbar, alpha)
        if actionbar == "bar3" then
            MultiBarBottomRight:SetAlpha(alpha)
        elseif actionbar == "bar4" then
            MultiBarRight:SetAlpha(alpha)
        elseif actionbar == "bar5" then
            MultiBarLeft:SetAlpha(alpha)
        elseif actionbar == "stancebar" then
            if not SUIStanceBar then return end
            SUIStanceBar:SetAlpha(alpha)
        end
    end

    local ABtimer1

    function MouseoverDefaultBars:onMouseover(actionbar)
        if actionbar == "bar3" then
            local ABtimer3
            for i = 1, 12 do
                if not MouseoverDefaultBars:IsHooked(_G["MultiBarBottomRightButton" .. i], "OnEnter") then
                    MouseoverDefaultBars:SecureHookScript(_G["MultiBarBottomRightButton" .. i], "OnEnter",
                        function() MouseoverDefaultBars:CancelTimer(ABtimer3); MouseoverDefaultBars:Alpha(actionbar, 1) end)
                end
                if not MouseoverDefaultBars:IsHooked(_G["MultiBarBottomRightButton" .. i], "OnLeave") then
                    MouseoverDefaultBars:SecureHookScript(_G["MultiBarBottomRightButton" .. i], "OnLeave",
                        function() ABtimer3 = MouseoverDefaultBars:ScheduleTimer(function() MouseoverDefaultBars:Alpha(actionbar
                                    , 0)
                            end, 0.1)
                        end)
                end
            end
        elseif actionbar == "bar4" then
            local ABtimer4
            for i = 1, 12 do
                if not MouseoverDefaultBars:IsHooked(_G["MultiBarRightButton" .. i], "OnEnter") then
                    MouseoverDefaultBars:SecureHookScript(_G["MultiBarRightButton" .. i], "OnEnter",
                        function() MouseoverDefaultBars:CancelTimer(ABtimer4); MouseoverDefaultBars:Alpha(actionbar, 1) end)
                end
                if not MouseoverDefaultBars:IsHooked(_G["MultiBarRightButton" .. i], "OnLeave") then
                    MouseoverDefaultBars:SecureHookScript(_G["MultiBarRightButton" .. i], "OnLeave",
                        function() ABtimer4 = MouseoverDefaultBars:ScheduleTimer(function() MouseoverDefaultBars:Alpha(actionbar
                                    , 0)
                            end, 0.1)
                        end)
                end
            end
        elseif actionbar == "bar5" then
            local ABtimer5
            for i = 1, 12 do
                if not MouseoverDefaultBars:IsHooked(_G["MultiBarLeftButton" .. i], "OnEnter") then
                    MouseoverDefaultBars:SecureHookScript(_G["MultiBarLeftButton" .. i], "OnEnter",
                        function() MouseoverDefaultBars:CancelTimer(ABtimer5); MouseoverDefaultBars:Alpha(actionbar, 1) end)
                end
                if not MouseoverDefaultBars:IsHooked(_G["MultiBarLeftButton" .. i], "OnLeave") then
                    MouseoverDefaultBars:SecureHookScript(_G["MultiBarLeftButton" .. i], "OnLeave",
                        function() ABtimer5 = MouseoverDefaultBars:ScheduleTimer(function() MouseoverDefaultBars:Alpha(actionbar
                                    , 0)
                            end, 0.1)
                        end)
                end
            end
        elseif actionbar == "stancebar" then --stance bar
            local ABtimer10
            for i = 1, 10 do
                if not MouseoverDefaultBars:IsHooked(_G["StanceButton" .. i], "OnEnter") then
                    MouseoverDefaultBars:SecureHookScript(_G["StanceButton" .. i], "OnEnter",
                        function() MouseoverDefaultBars:CancelTimer(ABtimer10); MouseoverDefaultBars:Alpha(actionbar, 1) end)
                end
                if not MouseoverDefaultBars:IsHooked(_G["StanceButton" .. i], "OnLeave") then
                    MouseoverDefaultBars:SecureHookScript(_G["StanceButton" .. i], "OnLeave",
                        function() ABtimer10 = MouseoverDefaultBars:ScheduleTimer(function() MouseoverDefaultBars:Alpha(actionbar
                                    , 0)
                            end, 0.1)
                        end)
                end
            end
        end
    end

    function MouseoverDefaultBars:ShowGrid()
        MouseoverDefaultBars:CancelAllTimers()
        MouseoverDefaultBars:UnhookAll()
        for i = 1, 10 do
            MouseoverDefaultBars:Alpha("bar" .. i, 1)
        end
    end

    function MouseoverDefaultBars:HideGrid()
        if not KeybindFrames_InQuickKeybindMode() then
            MouseoverDefaultBars:loadConfig()
        end
    end

    MouseoverDefaultBars:RegisterEvent("ACTIONBAR_SHOWGRID", "ShowGrid")
    MouseoverDefaultBars:RegisterEvent("ACTIONBAR_HIDEGRID", "HideGrid")
    MouseoverDefaultBars:RegisterEvent("PLAYER_ENTERING_WORLD", "loadConfig")
end
