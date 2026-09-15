--[[
    SUI 2.0 - Features/Chat/Common.lua

    Helpers shared by the chat features (ns.Chat): message event filters
    across the 12.x ChatFrameUtil rename, iterating chat frames including
    temporary whisper windows, and font lookup.
]]

local _, ns = ...
local SUI = ns.SUI

local _G, next, strfind = _G, next, string.find

local Chat = {}
ns.Chat = Chat

-- Message event filters ---------------------------------------------------------
function Chat.AddFilter(events, fn)
    local add = ChatFrameUtil and ChatFrameUtil.AddMessageEventFilter or ChatFrame_AddMessageEventFilter
    for i = 1, #events do
        add(events[i], fn)
    end
end

function Chat.RemoveFilter(events, fn)
    local remove = ChatFrameUtil and ChatFrameUtil.RemoveMessageEventFilter or ChatFrame_RemoveMessageEventFilter
    for i = 1, #events do
        remove(events[i], fn)
    end
end

-- Chat frames -----------------------------------------------------------------------
-- fn(frame, ...) for every chat frame Blizzard created so far.
function Chat.EachFrame(fn, ...)
    local names = CHAT_FRAMES
    for i = 1, #names do
        local frame = _G[names[i]]
        if frame then
            fn(frame, ...)
        end
    end
end

-- feature:method(frame) for temporary windows (whispers, pet battle log).
-- Runs one frame later, after Blizzard has docked and set the window up.
local listeners, pending = {}, {}

local function flush()
    for frame in next, pending do
        pending[frame] = nil
        for i = 1, #listeners do
            local l = listeners[i]
            if l.feature.enabled then
                l.feature[l.method](l.feature, frame)
            end
        end
    end
end

function Chat.OnNewFrame(feature, method)
    listeners[#listeners + 1] = { feature = feature, method = method }
    if #listeners == 1 and FCF_SetTemporaryWindowType then
        hooksecurefunc("FCF_SetTemporaryWindowType", function(frame)
            pending[frame] = true
            C_Timer.After(0, flush)
        end)
    end
end

-- Fonts -------------------------------------------------------------------------------
-- nil / "Default" -> fallback; a file path is used as is; else an LSM name.
function Chat.ResolveFont(name, fallback)
    if name == nil or name == "" or name == "Default" then
        return fallback
    end
    if strfind(name, "\\", 1, true) or strfind(name, "/", 1, true) then
        return name
    end
    return SUI.Media:Fetch("font", name) or fallback
end
