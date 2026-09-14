--[[
    SUI 2.0 - Core/Features.lua

    A feature describes what it does; the core decides whether it runs.

        local F = SUI:NewFeature("ActionBars.Range", {
            category = "actionbar",          -- SUI.db.profile.actionbar
            toggle   = "buttons.range",      -- path inside the category, or function(db) -> bool
            clients  = { Mainline = true },  -- nil = every client
        })
        function F:OnLoad()    end  -- once, before the first enable: frames, hooks
        function F:OnEnable()  end  -- turned on (login or option switched on)
        function F:OnDisable() end  -- turned off: undo visible changes
        function F:OnRefresh(key, value) end  -- an option in the category changed
        function F:OnThemeChanged() end        -- general theme/colour changed

    Events, unit events, timers and update loops registered through the
    feature are released automatically on disable. Hooks installed with
    F:Hook / F:HookScript only fire while the feature is enabled. That gate is
    the one enable check a feature ever needs.
]]

local _, ns = ...
local SUI = ns.SUI

local type, next = type, next
local xpcall, geterrorhandler = xpcall, geterrorhandler
local hooksecurefunc = hooksecurefunc
local strfind, strsub = string.find, string.sub

local Events = SUI.Events

local Feature = {}
Feature.__index = Feature
SUI.FeaturePrototype = Feature

local list = {}        -- registration order
local byId = {}
local byCategory = {}  -- category -> array of features (also filled by spec.watch)
SUI.features = byId

local function safecall(fn, ...)
    local args = { ... }
    local n = select("#", ...)
    return xpcall(function()
        return fn(unpack(args, 1, n))
    end, geterrorhandler())
end

-- Path helpers --------------------------------------------------------------
-- "a.b.c" -> t.a.b.c ; plain string search, no patterns.
local function getPath(t, path)
    local start = 1
    while t ~= nil do
        local dot = strfind(path, ".", start, true)
        if not dot then
            return t[strsub(path, start)]
        end
        t = t[strsub(path, start, dot - 1)]
        start = dot + 1
    end
    return nil
end

local function setPath(t, path, value)
    local start = 1
    while true do
        local dot = strfind(path, ".", start, true)
        if not dot then
            t[strsub(path, start)] = value
            return
        end
        local key = strsub(path, start, dot - 1)
        local child = t[key]
        if type(child) ~= "table" then
            child = {}
            t[key] = child
        end
        t = child
        start = dot + 1
    end
end

SUI.GetPath = getPath
SUI.SetPath = setPath

-- Registry --------------------------------------------------------------------
function SUI:NewFeature(id, spec)
    if byId[id] then
        error("SUI: feature " .. id .. " registered twice", 2)
    end
    spec = spec or {}
    local feature = setmetatable({
        id = id,
        category = spec.category,
        toggle = spec.toggle,
        clients = spec.clients,
        conflicts = spec.conflicts,
        reload = spec.reload,
        enabled = false,
        loaded = false,
    }, Feature)

    byId[id] = feature
    if not SUI:SupportsClient(spec.clients) then
        feature.unsupported = true
        return feature
    end

    list[#list + 1] = feature
    local function index(category)
        local bucket = byCategory[category]
        if not bucket then
            bucket = {}
            byCategory[category] = bucket
        end
        bucket[#bucket + 1] = feature
    end
    if spec.category then
        index(spec.category)
    end
    if spec.watch then
        for i = 1, #spec.watch do
            index(spec.watch[i])
        end
    end
    return feature
end

function SUI:GetFeature(id)
    return byId[id]
end

-- Decides whether a feature should currently run.
local function shouldRun(feature)
    if feature.unsupported then
        return false
    end
    local conflicts = feature.conflicts
    if conflicts then
        for i = 1, #conflicts do
            if SUI.Compat.IsAddOnLoaded(conflicts[i]) then
                return false
            end
        end
    end
    local toggle = feature.toggle
    if toggle == nil then
        return true
    end
    local db = feature.db
    if type(toggle) == "function" then
        return toggle(db) and true or false
    end
    local value = db and getPath(db, toggle)
    return value ~= nil and value ~= false and value ~= "Disabled"
end

local function bindDb(feature)
    local category = feature.category
    feature.db = category and SUI.db.profile[category] or SUI.db.profile
end

function Feature:Enable()
    if self.enabled or self.unsupported then
        return
    end
    if not self.loaded then
        self.loaded = true
        self.__loading = true
        if self.OnLoad then
            safecall(self.OnLoad, self)
        end
        self.__loading = nil
    end
    self.enabled = true
    if self.OnEnable then
        safecall(self.OnEnable, self)
    end
end

function Feature:Disable()
    if not self.enabled then
        return
    end
    self.enabled = false
    Events:UnregisterAll(self)
    self:CancelTimers()
    self:StopUpdate()
    if self.OnDisable then
        safecall(self.OnDisable, self)
    end
    if self.reload then
        SUI:RequestReload(self.id)
    end
end

-- Re-evaluates the feature against the current settings.
function Feature:Evaluate(key, value)
    bindDb(self)
    local run = shouldRun(self)
    if run and not self.enabled then
        self:Enable()
    elseif not run and self.enabled then
        self:Disable()
    elseif run and self.OnRefresh then
        safecall(self.OnRefresh, self, key, value)
    end
end

-- Events ------------------------------------------------------------------------
function Feature:RegisterEvent(event, fn)
    Events:Register(self, event, fn)
end

function Feature:UnregisterEvent(event)
    Events:Unregister(self, event)
end

function Feature:RegisterUnitEvent(event, fn, unit1, unit2)
    Events:RegisterUnit(self, event, fn, unit1, unit2)
end

function Feature:UnregisterUnitEvent(event)
    Events:UnregisterUnit(self, event)
end

-- Hooks -------------------------------------------------------------------------
-- Secure hooks cannot be removed, so they are installed once (in OnLoad) and
-- gated by the enabled flag.
function Feature:Hook(target, method, fn)
    if not self.__loading then
        error("SUI: " .. self.id .. ":Hook must be called from OnLoad", 2)
    end
    local feature = self
    if type(target) == "string" then
        fn = method
        hooksecurefunc(target, function(...)
            if feature.enabled then
                fn(...)
            end
        end)
    else
        hooksecurefunc(target, method, function(...)
            if feature.enabled then
                fn(...)
            end
        end)
    end
end

function Feature:HookScript(frame, script, fn)
    if not self.__loading then
        error("SUI: " .. self.id .. ":HookScript must be called from OnLoad", 2)
    end
    local feature = self
    frame:HookScript(script, function(...)
        if feature.enabled then
            fn(...)
        end
    end)
end

-- Timers ------------------------------------------------------------------------
function Feature:After(seconds, fn)
    local feature = self
    C_Timer.After(seconds, function()
        if feature.enabled then
            fn()
        end
    end)
end

function Feature:NewTicker(seconds, fn)
    local ticker = C_Timer.NewTicker(seconds, fn)
    self.__tickers = self.__tickers or {}
    self.__tickers[ticker] = true
    return ticker
end

function Feature:CancelTimers()
    local tickers = self.__tickers
    if tickers then
        for ticker in next, tickers do
            ticker:Cancel()
        end
        self.__tickers = nil
    end
end

-- Update loop: fn(elapsedSinceLastRun) at most every `interval` seconds.
-- Stop it as soon as there is nothing left to do.
function Feature:StartUpdate(fn, interval)
    local driver = self.__driver
    if not driver then
        driver = CreateFrame("Frame")
        self.__driver = driver
    end
    interval = interval or 0
    local acc = 0
    driver:SetScript("OnUpdate", function(_, elapsed)
        acc = acc + elapsed
        if acc >= interval then
            local total = acc
            acc = 0
            fn(total)
        end
    end)
end

function Feature:StopUpdate()
    if self.__driver then
        self.__driver:SetScript("OnUpdate", nil)
    end
end

-- Settings ------------------------------------------------------------------------
function SUI:Get(path)
    return getPath(self.db.profile, path)
end

-- Writes a setting and applies it live: features in that category are
-- enabled, disabled or refreshed as needed.
function SUI:Set(path, value)
    setPath(self.db.profile, path, value)
    local dot = strfind(path, ".", 1, true)
    local category = dot and strsub(path, 1, dot - 1) or path
    local key = dot and strsub(path, dot + 1) or nil
    local bucket = byCategory[category]
    if bucket then
        for i = 1, #bucket do
            bucket[i]:Evaluate(key, value)
        end
    end
    self.callbacks:Fire("SettingChanged", category, key, value)
end

-- Lifecycle ---------------------------------------------------------------------
function SUI:EnableFeatures()
    for i = 1, #list do
        local feature = list[i]
        bindDb(feature)
        if shouldRun(feature) then
            feature:Enable()
        end
    end
end

function SUI:ReevaluateFeatures()
    for i = 1, #list do
        list[i]:Evaluate()
    end
end

function SUI:NotifyThemeChanged()
    for i = 1, #list do
        local feature = list[i]
        if feature.enabled and feature.OnThemeChanged then
            safecall(feature.OnThemeChanged, feature)
        end
    end
    self.callbacks:Fire("ThemeChanged")
end

-- Reload requests -------------------------------------------------------------------
StaticPopupDialogs["SUI_RELOAD"] = {
    text = "|cffea00ffS|r|cff00a2ffUI|r: Some changes only take full effect after reloading the interface.",
    button1 = RELOADUI or "Reload UI",
    button2 = LATER or "Later",
    OnAccept = function()
        ReloadUI()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

function SUI:RequestReload(reason)
    if not self.reloadPending then
        self.reloadPending = true
        self:Debug("reload requested by", reason)
    end
    self.callbacks:Fire("ReloadRequested", reason)
end
