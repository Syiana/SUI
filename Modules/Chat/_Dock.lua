local SUIAddon = SUI
local Style = SUIAddon:GetModule("Chat.Modern")

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc

local alertingFrames = {}

-- Fading constants
local DOCK_FADE_IN_DURATION = 0.2

function Style:HandleDock(frame)
    frame:SetHeight(20)
    frame.scrollFrame:SetHeight(20)
    frame.scrollFrame.child:SetHeight(20)

    frame.scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    hooksecurefunc(frame.scrollFrame, "SetPoint", function(self, p, anchor, rP, x, _, shouldIgnore)
        if shouldIgnore then
            return
        end

        if p == "BOTTOMRIGHT" and anchor == frame then
            self:SetPoint(p, anchor, rP, x, 0, true)
        end
    end)

    Style:HandleOverflowButton(frame.overflowButton)
end

function Style:EnableAlerts()
    Style:SecureHook("FCF_StartAlertFlash", function(chatFrame)
        alertingFrames[chatFrame] = true

        Style:FadeIn(GeneralDockManager, DOCK_FADE_IN_DURATION)
    end)

    Style:SecureHook("FCF_StopAlertFlash", function(chatFrame)
        alertingFrames[chatFrame] = nil
    end)
end

function Style:ForChatFrame(id, method, ...)
    local frame = _G["ChatFrame" .. id]
    if frame and frame[method] then
        frame[method](frame, ...)
    end
end
