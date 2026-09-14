--[[
    SUI 2.0 - Features/General/Cosmetic.lua

    Hides the talking head (retail) and filters red UI error messages such as
    "Out of range". Both settings keep their 1.x meaning: the switch shows the
    Blizzard element, so the features run while it is off.
]]

local _, ns = ...
local SUI = ns.SUI

-- Talking head ----------------------------------------------------------------------
local TalkingHead = SUI:NewFeature("General.TalkingHead", {
    category = "general",
    toggle = function(db)
        return not db.cosmetic.talkhead
    end,
    clients = { Mainline = true },
})

local function closeTalkingHead()
    local frame = TalkingHeadFrame
    if frame and frame:IsShown() then
        if frame.CloseImmediately then
            frame:CloseImmediately()
        else
            frame:Hide()
        end
    end
end

function TalkingHead:OnLoad()
    if TalkingHeadFrame and TalkingHeadFrame.PlayCurrent then
        self:Hook(TalkingHeadFrame, "PlayCurrent", closeTalkingHead)
    end
end

function TalkingHead:OnEnable()
    -- Fallback for a talking head UI that is created after login.
    self:RegisterEvent("TALKINGHEAD_REQUESTED", function(feature)
        feature:After(0, closeTalkingHead)
    end)
    closeTalkingHead()
end

-- Error messages ------------------------------------------------------------------------
-- UIErrorsFrame stops listening to UI_ERROR_MESSAGE; SUI keeps the error
-- sound (as 1.x did) so failed actions are still noticeable.
local Errors = SUI:NewFeature("General.Errors", {
    category = "general",
    toggle = function(db)
        return not db.cosmetic.errors
    end,
})

function Errors:OnEnable()
    if not UIErrorsFrame then
        return
    end
    UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
    self:RegisterEvent("UI_ERROR_MESSAGE", "PlaySound")
end

function Errors:PlaySound(_, messageType)
    if not GetGameMessageInfo or not messageType then
        return
    end
    local _, soundKitID, voiceID = GetGameMessageInfo(messageType)
    if voiceID and C_Sound and C_Sound.PlayVocalErrorSound then
        C_Sound.PlayVocalErrorSound(voiceID)
    elseif soundKitID then
        PlaySound(soundKitID)
    end
end

function Errors:OnDisable()
    if UIErrorsFrame then
        UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
    end
end
