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

RF.RAID, RF.PARTY, RF.PET = 1, 2, 3

-- frame -> RF.RAID | RF.PARTY | RF.PET | false (weak: released frames may go)
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
        else
            kind = false
        end
        kinds[frame] = kind
    end
    return kind
end
RF.Classify = classify

-- Subscriptions -----------------------------------------------------------------
-- hook name -> { owners = {feature...}, fns = {fn...} }; fn(feature, frame)
local hooks = {}

function RF.On(hookName, feature, fn)
    local entry = hooks[hookName]
    if not entry then
        entry = { owners = {}, fns = {} }
        hooks[hookName] = entry
    end
    entry.owners[#entry.owners + 1] = feature
    entry.fns[#entry.fns + 1] = fn
end

local function dispatcher(entry)
    local owners, fns = entry.owners, entry.fns
    return function(frame)
        if not frame or not classify(frame) then
            return
        end
        for i = 1, #owners do
            local owner = owners[i]
            if owner.enabled then
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
local function visit(frame, fn, owner)
    if frame and classify(frame) then
        fn(owner, frame)
    end
end

function RF.ForEachFrame(fn, owner)
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
