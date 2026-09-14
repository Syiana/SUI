--[[
    SUI 2.0 - Core/Events.lua

    One frame dispatches every game event SUI listens to. Features never
    create their own event frames; they call self:RegisterEvent(...) and the
    registrations are dropped automatically when the feature is disabled.

    Unit events use RegisterUnitEvent on a small per-owner frame, because a
    shared frame can only hold one unit filter per event.
]]

local _, ns = ...
local SUI = ns.SUI

local next, type, error = next, type, error
local InCombatLockdown = InCombatLockdown

local Events = {}
SUI.Events = Events

local frame = CreateFrame("Frame")
local handlers = {} -- event -> array of { owner, fn, dead }
local dirty = {}    -- event -> true when entries were removed during dispatch
local depth = 0

local function resolve(owner, fn)
    if type(fn) == "string" then
        local method = owner[fn]
        if type(method) ~= "function" then
            error(("SUI.Events: %s has no method %q"):format(tostring(owner.id or owner), fn), 3)
        end
        return method
    end
    return fn
end

local function compact(event)
    local list = handlers[event]
    local j = 0
    for i = 1, #list do
        local entry = list[i]
        if not entry.dead then
            j = j + 1
            list[j] = entry
        end
    end
    for i = #list, j + 1, -1 do
        list[i] = nil
    end
    dirty[event] = nil
    if j == 0 then
        handlers[event] = nil
        frame:UnregisterEvent(event)
    end
end

frame:SetScript("OnEvent", function(_, event, ...)
    local list = handlers[event]
    if not list then
        return
    end
    depth = depth + 1
    -- The limit is evaluated once: handlers added during dispatch run next time.
    for i = 1, #list do
        local entry = list[i]
        if not entry.dead then
            entry.fn(entry.owner, event, ...)
        end
    end
    depth = depth - 1
    if depth == 0 and dirty[event] then
        compact(event)
    end
end)

-- fn(owner, event, ...) ; fn may be a method name on owner.
function Events:Register(owner, event, fn)
    fn = resolve(owner, fn or event)
    local list = handlers[event]
    if not list then
        list = {}
        handlers[event] = list
        frame:RegisterEvent(event)
    end
    for i = 1, #list do
        local entry = list[i]
        if entry.owner == owner and not entry.dead then
            entry.fn = fn
            return
        end
    end
    list[#list + 1] = { owner = owner, fn = fn }
end

function Events:Unregister(owner, event)
    local list = handlers[event]
    if not list then
        return
    end
    for i = 1, #list do
        local entry = list[i]
        if entry.owner == owner then
            entry.dead = true
            dirty[event] = true
        end
    end
    if depth == 0 and dirty[event] then
        compact(event)
    end
end

function Events:UnregisterAll(owner)
    for event in next, handlers do
        self:Unregister(owner, event)
    end
    local unitFrame = owner.__unitFrame
    if unitFrame then
        unitFrame:UnregisterAllEvents()
        owner.__unitHandlers = nil
    end
end

-- Unit events: fn(owner, event, unit, ...)
function Events:RegisterUnit(owner, event, fn, unit1, unit2)
    fn = resolve(owner, fn or event)
    local unitFrame = owner.__unitFrame
    if not unitFrame then
        unitFrame = CreateFrame("Frame")
        owner.__unitFrame = unitFrame
        unitFrame:SetScript("OnEvent", function(_, ev, ...)
            local h = owner.__unitHandlers and owner.__unitHandlers[ev]
            if h then
                h(owner, ev, ...)
            end
        end)
    end
    owner.__unitHandlers = owner.__unitHandlers or {}
    owner.__unitHandlers[event] = fn
    unitFrame:RegisterUnitEvent(event, unit1, unit2)
end

function Events:UnregisterUnit(owner, event)
    if owner.__unitFrame then
        owner.__unitFrame:UnregisterEvent(event)
        if owner.__unitHandlers then
            owner.__unitHandlers[event] = nil
        end
    end
end

-- Combat queue ----------------------------------------------------------------
-- Protected frames cannot be changed in combat. Queue the work instead of
-- failing; everything runs once combat ends, in the order it was queued.
local combatQueue = {}
local combatOwner = {}

function SUI:RunAfterCombat(fn)
    if not InCombatLockdown() then
        fn()
        return
    end
    combatQueue[#combatQueue + 1] = fn
    if #combatQueue == 1 then
        Events:Register(combatOwner, "PLAYER_REGEN_ENABLED", function()
            Events:Unregister(combatOwner, "PLAYER_REGEN_ENABLED")
            local queue = combatQueue
            combatQueue = {}
            for i = 1, #queue do
                queue[i]()
            end
        end)
    end
end

-- Load-on-demand add-ons ------------------------------------------------------
-- fn runs once the named add-on is loaded (immediately if it already is).
local addonWaiters = {}
local addonOwner = {}

function SUI:OnAddonLoaded(name, fn)
    if SUI.Compat.IsAddOnLoaded(name) then
        fn(name)
        return
    end
    local list = addonWaiters[name]
    if not list then
        list = {}
        addonWaiters[name] = list
    end
    list[#list + 1] = fn
    Events:Register(addonOwner, "ADDON_LOADED", function(_, _, loaded)
        local waiting = addonWaiters[loaded]
        if waiting then
            addonWaiters[loaded] = nil
            for i = 1, #waiting do
                waiting[i](loaded)
            end
        end
        if next(addonWaiters) == nil then
            Events:Unregister(addonOwner, "ADDON_LOADED")
        end
    end)
end
