--[[
    SUI 2.0 - Features/Chat/ShortChannels.lua

    Shortens channel and whisper tags: [1. General - Zone] -> [1],
    [Guild] -> [G], "Name whispers:" -> "[W] Name:". The chat event handler
    offers no clean hook for this: message filters cannot touch the channel
    tag (shortening arg4 breaks Blizzard's channel routing) and rewriting the
    CHAT_*_GET globals taints the whole handler. So each chat frame's
    AddMessage is wrapped, on every client. Secret (12.x) lines pass through
    untouched, but on Retail 12.x the wrapper still taints the remainder of
    Blizzard's chat handler, hence off by default.
]]

local _, ns = ...
local SUI = ns.SUI
local Chat = ns.Chat

local next, type, gsub, strfind, strsub, rawget = next, type, string.gsub, string.find, string.sub, rawget
local CanAccess = SUI.Compat.CanAccess

local F = SUI:NewFeature("Chat.ShortChannels", {
    category = "chat",
    toggle = "shortchannels",
})

-- Uppercase channel link types; unknown types keep their text.
local TAGS = {
    GUILD = "|Hchannel:GUILD|h[G]|h",
    OFFICER = "|Hchannel:OFFICER|h[O]|h",
    PARTY = "|Hchannel:PARTY|h[P]|h",
    PARTY_LEADER = "|Hchannel:PARTY_LEADER|h[PL]|h",
    RAID = "|Hchannel:RAID|h[R]|h",
    RAID_LEADER = "|Hchannel:RAID_LEADER|h[RL]|h",
    RAID_WARNING = "|Hchannel:RAID_WARNING|h[RW]|h",
    INSTANCE_CHAT = "|Hchannel:INSTANCE_CHAT|h[I]|h",
    INSTANCE_CHAT_LEADER = "|Hchannel:INSTANCE_CHAT_LEADER|h[IL]|h",
    BATTLEGROUND = "|Hchannel:BATTLEGROUND|h[BG]|h",
    BATTLEGROUND_LEADER = "|Hchannel:BATTLEGROUND_LEADER|h[BL]|h",
}

local originals = {} -- chat frame -> AddMessage stored on the frame itself (nil = widget method)
local callers = {}   -- chat frame -> AddMessage to call
local whisperFrom    -- "|h whispers: " (after the sender link)
local whisperTo      -- "To |H" (before the target link)

local function shorten(text)
    if strfind(text, "|Hchannel:", 1, true) then
        text = gsub(text, "|Hchannel:([%u_]+)|h%[[^%]]*%]|h", TAGS)
        text = gsub(text, "|Hchannel:channel:(%d+)|h%[[^%]]*%]|h", "|Hchannel:channel:%1|h[%1]|h")
    end
    if whisperFrom then
        local a, b = strfind(text, whisperFrom, 1, true)
        if a then
            return "[W] " .. strsub(text, 1, a + 1) .. ": " .. strsub(text, b + 1)
        end
    end
    if whisperTo then
        local a, b = strfind(text, whisperTo, 1, true)
        if a then
            return strsub(text, 1, a - 1) .. "[W] @|H" .. strsub(text, b + 1)
        end
    end
    return text
end

local function addMessage(frame, text, ...)
    if F.enabled and CanAccess(text) and type(text) == "string" then
        text = shorten(text)
    end
    return callers[frame](frame, text, ...)
end

function F:Wrap(frame)
    if callers[frame] or frame == ChatFrame2 then -- ChatFrame2 is the combat log
        return
    end
    originals[frame] = rawget(frame, "AddMessage")
    callers[frame] = frame.AddMessage
    frame.AddMessage = addMessage
end

-- Splits a localized "... %s ..." format into the text before and after %s.
local function split(fmt)
    local a, b
    if type(fmt) == "string" then
        a, b = strfind(fmt, "%s", 1, true)
    end
    if a then
        return strsub(fmt, 1, a - 1), strsub(fmt, b + 1)
    end
end

function F:OnLoad()
    local _, after = split(CHAT_WHISPER_GET)
    if after and after ~= "" and after ~= ": " then
        whisperFrom = "|h" .. after
    end
    local before = split(CHAT_WHISPER_INFORM_GET)
    if before and before ~= "" then
        whisperTo = before .. "|H"
    end
    Chat.OnNewFrame(self, "Wrap")
end

function F:OnEnable()
    Chat.EachFrame(self.Wrap, self)
end

function F:OnDisable()
    -- Unwrap unless another add-on wrapped on top of us; then stay as a pass-through.
    for frame in next, callers do
        if rawget(frame, "AddMessage") == addMessage then
            frame.AddMessage = originals[frame]
            callers[frame], originals[frame] = nil, nil
        end
    end
end
