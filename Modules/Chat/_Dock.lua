local SUIAddon = SUI
local Style = SUIAddon:GetModule("Chat.Modern")

local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc

local DOCK_HEIGHT = 20
local DOCK_FADE_IN_DURATION = 0.2
local alertFrames = setmetatable({}, {__mode = "k"})

local function applyDockHeight(frame)
    frame:SetHeight(DOCK_HEIGHT)
    frame.scrollFrame:SetHeight(DOCK_HEIGHT)
    frame.scrollFrame.child:SetHeight(DOCK_HEIGHT)
end

local function pinScrollFrame(frame)
    if frame.SUIScrollFramePinned then
        return
    end

    hooksecurefunc(frame.scrollFrame, "SetPoint", function(scrollFrame, point, anchor, relativePoint, offsetX, _, bypass)
        if bypass or point ~= "BOTTOMRIGHT" or anchor ~= frame then
            return
        end

        scrollFrame:SetPoint(point, anchor, relativePoint, offsetX, 0, true)
    end)

    frame.SUIScrollFramePinned = true
end

local function hasAlerts()
    return next(alertFrames) ~= nil
end

function Style:HandleDock(frame)
    if not frame then
        return
    end

    applyDockHeight(frame)
    frame.scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    pinScrollFrame(frame)
    Style:HandleOverflowButton(frame.overflowButton)
end

function Style:EnableAlerts()
    Style:SecureHook("FCF_StartAlertFlash", function(chatFrame)
        alertFrames[chatFrame] = true
        Style:FadeIn(GeneralDockManager, DOCK_FADE_IN_DURATION)
    end)

    Style:SecureHook("FCF_StopAlertFlash", function(chatFrame)
        alertFrames[chatFrame] = nil
        if not hasAlerts() then
            Style:StopFading(GeneralDockManager, GeneralDockManager:GetAlpha())
        end
    end)
end
