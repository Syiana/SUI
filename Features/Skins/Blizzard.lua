--[[
    SUI 2.0 - Features/Skins/Blizzard.lua

    Turns the skin tables (Shared.lua, Retail.lua, Classic.lua) into
    SUI.Skin registrations. A group is a list of frame paths plus a few
    optional fields; the loader below is the only code that walks them.

        {
            addon   = "Blizzard_MacroUI",          -- nil = frames present at login
            clients = { Mainline = true },          -- nil = every client of that table
            protect = { "MacroFrame#18" },          -- regions that keep their colours
            hide    = { "SomeFrame" },              -- SetAlpha(0)
            grey    = { "SomeButton#1" },           -- flat grey instead of theme colour
            run     = function(Skin, S, feature) end, -- real special cases only
            "MacroFrame", "MacroFrame.NineSlice", "MacroFrameTab1",
        }

    Paths are dot separated from _G. Numeric parts index arrays
    ("Frame.TabSystem.tabs.1") and "#n" picks the n-th region ("#-1" = last).
]]

local _, ns = ...
local SUI = ns.SUI

local _G, type, select, tonumber, hooksecurefunc = _G, type, select, tonumber, hooksecurefunc

local S = { Mainline = {}, Classic = {}, Shared = {} }
ns.Skins = S

function S.Resolve(path)
    if type(path) ~= "string" then
        return path
    end
    local base, index = path:match("^(.-)#(%-?%d+)$")
    local obj = _G
    for part in (base or path):gmatch("[^%.]+") do
        if type(obj) ~= "table" then
            return nil
        end
        obj = obj[tonumber(part) or part]
    end
    if type(obj) ~= "table" then
        return nil
    end
    if index then
        if not obj.GetRegions then
            return nil
        end
        index = tonumber(index)
        if index < 0 then
            index = obj:GetNumRegions() + 1 + index
        end
        if index < 1 then
            return nil
        end
        obj = select(index, obj:GetRegions())
    end
    return obj
end
local resolve = S.Resolve

-- Secure hooks for frames that only exist once a load-on-demand add-on has
-- loaded (Feature:Hook only works in OnLoad). Gated like Feature:Hook.
function S.Hook(feature, target, method, fn)
    if target and target[method] then
        hooksecurefunc(target, method, function(...)
            if feature.enabled then
                fn(...)
            end
        end)
    end
end

function S.HookScript(feature, frame, script, fn)
    if frame and frame.HookScript then
        frame:HookScript(script, function(...)
            if feature.enabled then
                fn(...)
            end
        end)
    end
end

local function applyGroup(group, Skin, feature)
    local list = group.protect
    if list then
        for i = 1, #list do
            Skin:Protect(resolve(list[i]))
        end
    end
    for i = 1, #group do
        Skin:Frame(resolve(group[i]), true)
    end
    list = group.grey
    if list then
        for i = 1, #list do
            Skin:Frame(resolve(list[i]), false)
        end
    end
    list = group.hide
    if list then
        for i = 1, #list do
            local obj = resolve(list[i])
            if obj and obj.SetAlpha then
                obj:SetAlpha(0)
            end
        end
    end
    if group.run then
        group.run(Skin, S, feature)
    end
end

-- Registers every group of `groups` that applies to the running client.
function S.Register(feature, groups)
    for i = 1, #groups do
        local group = groups[i]
        if SUI:SupportsClient(group.clients) then
            SUI.Skin:Register(group.addon or "SUI", function(Skin)
                applyGroup(group, Skin, feature)
            end)
        end
    end
end

-- Blizzard frames -------------------------------------------------------------------
local F = SUI:NewFeature("Skins.Blizzard", {
    category = "skins",
    toggle = "blizzard",
    reload = true,
})

-- Registrations cannot be taken back; a disable asks for a reload instead,
-- so re-enabling without one must not register everything twice.
function F:OnEnable()
    if self.registered then
        return
    end
    self.registered = true
    -- Client tables first: their protect lists must run before the shared
    -- groups paint the same frames.
    S.Register(self, SUI.IsRetail and S.Mainline or S.Classic)
    S.Register(self, S.Shared)
end
