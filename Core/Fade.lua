--[[
    SUI 2.0 - Core/Fade.lua

    Blizzard's UIFrameFade family runs every fade from one shared manager
    frame and re-installs its OnUpdate on each call. Calling it from SUI
    taints that handler, so Blizzard's own fades (chat tabs, for one) later
    run tainted and error on secret values. SUI runs its own manager and
    never touches Blizzard's. Never call UIFrameFade* from SUI code.
]]

local _, ns = ...
local SUI = ns.SUI

local next = next

local fading = {}
local manager = CreateFrame("Frame")

local function finish(frame, info)
    fading[frame] = nil
    if next(fading) == nil then
        manager:SetScript("OnUpdate", nil)
    end
    local done = info.finishedFunc
    if done then
        info.finishedFunc = nil
        done(info.finishedArg1, info.finishedArg2, info.finishedArg3, info.finishedArg4)
    end
end

local function onUpdate(_, elapsed)
    for frame, info in next, fading do
        info.fadeTimer = info.fadeTimer + elapsed
        if info.fadeTimer < info.timeToFade then
            frame:SetAlpha(info.startAlpha + (info.endAlpha - info.startAlpha) * info.fadeTimer / info.timeToFade)
        else
            frame:SetAlpha(info.endAlpha)
            if info.fadeHoldTime and info.fadeHoldTime > 0 then
                info.fadeHoldTime = info.fadeHoldTime - elapsed
            else
                finish(frame, info)
            end
        end
    end
end

-- Same fields as UIFrameFade: mode ("IN"/"OUT"), timeToFade, startAlpha,
-- endAlpha, fadeHoldTime, finishedFunc, finishedArg1-4.
function SUI:FadeFrame(frame, info)
    if not frame or not info then
        return
    end
    info.mode = info.mode or "IN"
    info.timeToFade = info.timeToFade or 0.2
    info.fadeTimer = 0
    if info.mode == "IN" then
        info.startAlpha = info.startAlpha or 0
        info.endAlpha = info.endAlpha or 1
    else
        info.startAlpha = info.startAlpha or 1
        info.endAlpha = info.endAlpha or 0
    end
    frame:SetAlpha(info.startAlpha)
    frame:Show()
    if info.timeToFade <= 0 then
        frame:SetAlpha(info.endAlpha)
        return finish(frame, info)
    end
    fading[frame] = info
    if not manager:GetScript("OnUpdate") then
        manager:SetScript("OnUpdate", onUpdate)
    end
end

function SUI:FadeIn(frame, timeToFade, startAlpha, endAlpha)
    self:FadeFrame(frame, { mode = "IN", timeToFade = timeToFade, startAlpha = startAlpha, endAlpha = endAlpha })
end

function SUI:FadeOut(frame, timeToFade, startAlpha, endAlpha)
    self:FadeFrame(frame, { mode = "OUT", timeToFade = timeToFade, startAlpha = startAlpha, endAlpha = endAlpha })
end

function SUI:StopFading(frame)
    if frame and fading[frame] then
        fading[frame] = nil
        if next(fading) == nil then
            manager:SetScript("OnUpdate", nil)
        end
    end
end
