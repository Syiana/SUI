--[[
    SUI 2.0 - Features/RaidFrames/Core.lua

    Shared plumbing for the raid frame features. CompactUnitFrame functions
    are hooked exactly once here; each hook classifies the frame once (cached)
    and returns early for nameplates, arena and forbidden frames before
    handing raid and party frames to the features that subscribed.
]]

local _, ns = ...
local SUI = ns.SUI

local _G, type, strfind = _G, type, string.find

local RF = {}
ns.RaidFrames = RF

RF.RAID, RF.PARTY, RF.PET, RF.ARENA = 1, 2, 3, 4
local ARENA = RF.ARENA

-- frame -> RF.RAID | RF.PARTY | RF.PET | RF.ARENA | false (weak: released frames may go)
local kinds = setmetatable({}, { __mode = "k" })
RF.kind = kinds

local function classify(frame)
    if frame:IsForbidden() then
        return false
    end
    local kind = kinds[frame]
    if kind == nil then
        local name = frame:GetName()
        if not name then
            kind = false
        elseif strfind(name, "^CompactPartyFramePet") then
            kind = RF.PET
        elseif strfind(name, "^CompactPartyFrameMember") then
            kind = RF.PARTY
        elseif strfind(name, "^CompactRaid") then
            kind = RF.RAID
        elseif strfind(name, "^CompactArenaFrame") then
            kind = ARENA
        else
            kind = false
        end
        kinds[frame] = kind
    end
    return kind
end
RF.Classify = classify

-- Subscriptions -----------------------------------------------------------------
-- hook name -> { owners = {feature...}, fns = {fn...}, arena = {bool...} };
-- fn(feature, frame). Arena frames only reach subscribers that ask for them
-- (1.x styled every "Compact" frame's bars, nothing else).
local hooks = {}

function RF.On(hookName, feature, fn, withArena)
    local entry = hooks[hookName]
    if not entry then
        entry = { owners = {}, fns = {}, arena = {} }
        hooks[hookName] = entry
    end
    local n = #entry.owners + 1
    entry.owners[n], entry.fns[n], entry.arena[n] = feature, fn, withArena == true
end

local function dispatcher(entry)
    local owners, fns, arena = entry.owners, entry.fns, entry.arena
    return function(frame)
        if not frame then
            return
        end
        local kind = classify(frame)
        if not kind then
            return
        end
        for i = 1, #owners do
            local owner = owners[i]
            if owner.enabled and (kind ~= ARENA or arena[i]) then
                fns[i](owner, frame)
            end
        end
    end
end

local Core = SUI:NewFeature("RaidFrames.Core", { category = "raidframes" })

function Core:OnLoad()
    for hookName, entry in pairs(hooks) do
        if type(_G[hookName]) == "function" then
            self:Hook(hookName, dispatcher(entry))
        end
    end
end

-- Calls fn(owner, frame) for every existing raid and party frame. Not a hot
-- path: used when a setting changes or a feature is switched.
local function visit(frame, fn, owner, withArena)
    if frame then
        local kind = classify(frame)
        if kind and (kind ~= ARENA or withArena) then
            fn(owner, frame)
        end
    end
end

-- withArena: also visit CompactArenaFrame members.
function RF.ForEachFrame(fn, owner, withArena)
    for i = 1, 100 do -- raid members, pets and target frames are numbered in creation order
        local frame = _G["CompactRaidFrame" .. i]
        if not frame then
            break
        end
        visit(frame, fn, owner)
    end
    for group = 1, 8 do
        for member = 1, 5 do
            visit(_G["CompactRaidGroup" .. group .. "Member" .. member], fn, owner)
        end
    end
    for member = 1, 5 do
        visit(_G["CompactPartyFrameMember" .. member], fn, owner)
        visit(_G["CompactPartyFramePet" .. member], fn, owner)
        if withArena then
            visit(_G["CompactArenaFrameMember" .. member], fn, owner, true)
        end
    end
end

-- Font strings: remember Blizzard's font and colour on first touch so a
-- feature can hand them back when it is switched off.
local originals = setmetatable({}, { __mode = "k" })

local function remember(fs)
    local o = originals[fs]
    if not o then
        o = { fs:GetFont() }
        o.r, o.g, o.b = fs:GetTextColor()
        originals[fs] = o
    end
    return o
end

-- font "" restores Blizzard's font.
function RF.SetFont(fs, font, size)
    local o = remember(fs)
    if font == "" then
        if o[1] then
            fs:SetFont(o[1], o[2], o[3])
        end
    else
        fs:SetFont(font, size, "OUTLINE")
    end
end

function RF.RestoreFont(fs)
    local o = originals[fs]
    if o then
        if o[1] then
            fs:SetFont(o[1], o[2], o[3])
        end
        fs:SetTextColor(o.r, o.g, o.b)
    end
end

function RF.RestoreColor(fs)
    local o = originals[fs]
    if o then
        fs:SetTextColor(o.r, o.g, o.b)
    end
end

function RF.Remember(fs)
    remember(fs)
end
