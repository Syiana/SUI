--[[
    SUI 2.0 - Core/Init.lua

    Creates the addon object and answers the one question every other file
    would otherwise ask again and again: which client are we running on.
    Everything here is decided once at load time.
]]

local addonName, ns = ...

local SUI = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0", "AceConsole-3.0")
ns.SUI = SUI
_G.SUI = SUI

SUI.name = addonName
SUI.version = C_AddOns and C_AddOns.GetAddOnMetadata(addonName, "Version") or GetAddOnMetadata(addonName, "Version")
SUI.mediaPath = [[Interface\AddOns\]] .. addonName .. [[\Media\]]
SUI.brand = "|cffea00ffS|r|cff00a2ffUI|r"
SUI.callbacks = LibStub("CallbackHandler-1.0"):New(SUI)
-- CallbackHandler puts Register/Unregister on the target (SUI). Mirror them on
-- the registry so SUI.callbacks.RegisterCallback(owner, event, fn) works too.
-- One owner holds one handler per event: use a distinct owner table per listener.
SUI.callbacks.RegisterCallback = SUI.RegisterCallback
SUI.callbacks.UnregisterCallback = SUI.UnregisterCallback
SUI.callbacks.UnregisterAllCallbacks = SUI.UnregisterAllCallbacks

-- Client detection --------------------------------------------------------
-- WOW_PROJECT_* constants do not exist on every client, so compare against
-- the raw ids as a fallback.
local project = WOW_PROJECT_ID
local MAINLINE = WOW_PROJECT_MAINLINE or 1
local VANILLA = WOW_PROJECT_CLASSIC or 2
local TBC = WOW_PROJECT_BURNING_CRUSADE_CLASSIC or 5
local MISTS = WOW_PROJECT_MISTS_CLASSIC or 19

SUI.IsRetail = project == MAINLINE
SUI.IsVanilla = project == VANILLA
SUI.IsTBC = project == TBC
SUI.IsMists = project == MISTS
SUI.IsClassic = not SUI.IsRetail

if SUI.IsRetail then
    SUI.Client = "Mainline"
elseif SUI.IsMists then
    SUI.Client = "Mists"
elseif SUI.IsTBC then
    SUI.Client = "TBC"
elseif SUI.IsVanilla then
    SUI.Client = "Vanilla"
else
    -- Unknown classic flavour (e.g. a future progression server): behave like
    -- the closest supported one instead of failing.
    SUI.Client = "Mists"
    SUI.IsMists = true
end

-- Retail since 10.0 has Edit Mode, the classic clients do not.
SUI.HasEditMode = EditModeManagerFrame ~= nil

-- True when a feature spec's client list includes the running client.
-- `clients` may be nil (all), a string ("Mainline") or a set { Mainline = true }.
function SUI:SupportsClient(clients)
    if clients == nil then
        return true
    end
    if type(clients) == "string" then
        return clients == self.Client or (clients == "Classic" and self.IsClassic)
    end
    return clients[self.Client] == true or (clients.Classic == true and self.IsClassic)
end

-- Output ------------------------------------------------------------------
function SUI:Print(...)
    print(self.brand .. ":", ...)
end

function SUI:Debug(...)
    if self.db and self.db.global.debug then
        print("|cff888888SUI debug:|r", ...)
    end
end

-- Throttle: run fn at most once per `seconds` for a given key.
local throttled = {}
function SUI:Throttle(key, seconds, fn)
    if throttled[key] then
        return
    end
    throttled[key] = true
    C_Timer.After(seconds, function()
        throttled[key] = nil
        fn()
    end)
end

-- Other UI replacements that fight over the same frames.
local CONFLICTS = { "LortiUI", "UberUI" }
for i = 1, #CONFLICTS do
    local disable = C_AddOns and C_AddOns.DisableAddOn or DisableAddOn
    if disable then
        disable(CONFLICTS[i])
    end
end
