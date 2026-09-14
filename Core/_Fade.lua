-- Blizzard's UIFrameFade family drives every fade it starts from one shared
-- manager frame, and each call re-installs that frame's OnUpdate handler.
-- Calling it from SUI therefore taints the handler permanently, so every fade
-- Blizzard later runs through it -- chat tab mouseover fades, for one --
-- executes tainted by us and errors the moment it touches a secret value.
-- We run our own manager instead and never write to theirs.

local fading = {}
local manager = CreateFrame("Frame", "SUIFadeManager")

local function finish(frame, fadeInfo)
    fading[frame] = nil

    if not next(fading) then
        manager:SetScript("OnUpdate", nil)
    end

    local finishedFunc = fadeInfo.finishedFunc
    if finishedFunc then
        fadeInfo.finishedFunc = nil
        finishedFunc(fadeInfo.finishedArg1, fadeInfo.finishedArg2, fadeInfo.finishedArg3, fadeInfo.finishedArg4)
    end
end

local function manager_OnUpdate(_, elapsed)
    for frame, fadeInfo in next, fading do
        fadeInfo.fadeTimer = fadeInfo.fadeTimer + elapsed

        if fadeInfo.fadeTimer < fadeInfo.timeToFade then
            local progress = fadeInfo.fadeTimer / fadeInfo.timeToFade
            frame:SetAlpha(progress * (fadeInfo.endAlpha - fadeInfo.startAlpha) + fadeInfo.startAlpha)
        else
            frame:SetAlpha(fadeInfo.endAlpha)

            if fadeInfo.fadeHoldTime and fadeInfo.fadeHoldTime > 0 then
                fadeInfo.fadeHoldTime = fadeInfo.fadeHoldTime - elapsed
            else
                finish(frame, fadeInfo)
            end
        end
    end
end

--- Drop-in replacement for UIFrameFade.
--- @param frame Frame
--- @param fadeInfo table mode/timeToFade/startAlpha/endAlpha/fadeHoldTime/finishedFunc/finishedArg1-4
function SUI:FadeFrame(frame, fadeInfo)
    if not frame or not fadeInfo then
        return
    end

    fadeInfo.mode = fadeInfo.mode or "IN"
    fadeInfo.timeToFade = fadeInfo.timeToFade or 0.2
    fadeInfo.fadeTimer = 0

    if fadeInfo.mode == "IN" then
        fadeInfo.startAlpha = fadeInfo.startAlpha or 0
        fadeInfo.endAlpha = fadeInfo.endAlpha or 1
    else
        fadeInfo.startAlpha = fadeInfo.startAlpha or 1
        fadeInfo.endAlpha = fadeInfo.endAlpha or 0
    end

    frame:SetAlpha(fadeInfo.startAlpha)
    frame:Show()

    if fadeInfo.timeToFade <= 0 then
        frame:SetAlpha(fadeInfo.endAlpha)
        return finish(frame, fadeInfo)
    end

    fading[frame] = fadeInfo

    if not manager:GetScript("OnUpdate") then
        manager:SetScript("OnUpdate", manager_OnUpdate)
    end
end

--- Drop-in replacement for UIFrameFadeIn.
function SUI:FadeIn(frame, timeToFade, startAlpha, endAlpha)
    self:FadeFrame(frame, {
        mode = "IN",
        timeToFade = timeToFade,
        startAlpha = startAlpha,
        endAlpha = endAlpha
    })
end

--- Drop-in replacement for UIFrameFadeOut.
function SUI:FadeOut(frame, timeToFade, startAlpha, endAlpha)
    self:FadeFrame(frame, {
        mode = "OUT",
        timeToFade = timeToFade,
        startAlpha = startAlpha,
        endAlpha = endAlpha
    })
end

--- Drop-in replacement for UIFrameFadeRemoveFrame.
function SUI:StopFading(frame)
    if not frame or not fading[frame] then
        return
    end

    fading[frame] = nil

    if not next(fading) then
        manager:SetScript("OnUpdate", nil)
    end
end
