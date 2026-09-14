--[[
    SUI 2.0 - Core/Database.lua

    Defaults are registered per category by the feature folders, so there is
    no central defaults file to keep in sync:

        SUI:RegisterDefaults("actionbar", { buttons = { range = true } })

    Scopes: "profile" (default, per profile), "global" (account wide state
    such as the install flag), "char" (per character).

    Migrations are named, run once per profile in registration order, and
    must be idempotent. Use rawget on the profile to see what a user really
    stored, because AceDB fills missing keys from the defaults.

        SUI:RegisterMigration("chat-style-v2", function(profile) ... end)

    Lists the user edits (e.g. NPC colours) must not live in the defaults:
    AceDB re-adds default list entries the user removed. Seed them from the
    feature on first run instead.
]]

local _, ns = ...
local SUI = ns.SUI

local type, pairs, next, rawget = type, pairs, next, rawget

local defaults = {
    profile = {},
    global = {
        installed = false,
        debug = false,
        newVersion = false,
    },
    char = {},
}

-- Several files may contribute to one category; keys must not collide.
function SUI:RegisterDefaults(category, values, scope)
    local target = defaults[scope or "profile"]
    local existing = target[category]
    if existing == nil then
        target[category] = values
        return
    end
    for key, value in pairs(values) do
        if existing[key] ~= nil then
            error(("SUI: default %s.%s registered twice"):format(category, key), 2)
        end
        existing[key] = value
    end
end

function SUI:GetDefaults(category, scope)
    return defaults[scope or "profile"][category]
end

-- Migrations ------------------------------------------------------------------
local migrations = {}

function SUI:RegisterMigration(name, fn)
    migrations[#migrations + 1] = { name = name, fn = fn }
end

local function runMigrations(profile)
    local done = rawget(profile, "migrations")
    if type(done) ~= "table" then
        done = {}
        profile.migrations = done
    end
    for i = 1, #migrations do
        local m = migrations[i]
        if not done[m.name] then
            local ok, err = pcall(m.fn, profile, SUI.db)
            if ok then
                done[m.name] = true
            else
                geterrorhandler()(("SUI migration %s failed: %s"):format(m.name, tostring(err)))
            end
        end
    end
end

-- Core migration: SUI 1.x stored account state inside the profile.
SUI:RegisterMigration("core-1x-state", function(profile, db)
    if rawget(profile, "install") then
        db.global.installed = true
    end
    profile.install = nil
    profile.reset = nil
    profile.new_version = nil
end)

-- Import / export ---------------------------------------------------------------
-- Copies only keys that exist in the defaults and have the same type. Tables
-- without a defaults counterpart (lists, user data) are copied as a whole.
local function isList(t)
    return type(t) == "table" and (next(t) == nil or t[1] ~= nil)
end

local function sanitizedCopy(source, template)
    local out = {}
    for key, value in pairs(source) do
        local def = template and template[key]
        if def == nil then
            if template == nil then
                out[key] = type(value) == "table" and CopyTable(value) or value
            end
        elseif type(def) == type(value) then
            if type(value) == "table" and not isList(def) then
                out[key] = sanitizedCopy(value, def)
            else
                out[key] = type(value) == "table" and CopyTable(value) or value
            end
        end
    end
    return out
end

local EXPORT_PREFIX = "SUI2:"

function SUI:ExportProfile()
    local LibDeflate = LibStub("LibDeflate")
    local data = CopyTable(self.db.profile)
    data.migrations = nil
    local serialized = self:Serialize(data)
    return EXPORT_PREFIX .. LibDeflate:EncodeForPrint(LibDeflate:CompressZlib(serialized))
end

-- Returns decoded profile table or nil, errorMessage. Accepts SUI 1.x strings.
function SUI:DecodeProfile(text)
    if type(text) ~= "string" or text == "" then
        return nil, "No import string provided."
    end
    text = text:gsub("^%s+", ""):gsub("%s+$", "")
    local isV2 = text:sub(1, #EXPORT_PREFIX) == EXPORT_PREFIX
    if isV2 then
        text = text:sub(#EXPORT_PREFIX + 1)
    end
    local LibDeflate = LibStub("LibDeflate")
    local decoded = LibDeflate:DecodeForPrint(text)
    local inflated = decoded and LibDeflate:DecompressZlib(decoded)
    if not inflated then
        return nil, "This is not a valid SUI profile string."
    end
    local ok, data = self:Deserialize(inflated)
    if not ok or type(data) ~= "table" then
        return nil, "This is not a valid SUI profile string."
    end
    return data, isV2
end

-- Replaces the current profile with imported data and applies it live.
function SUI:ImportProfile(data, isV2)
    local profile = self.db.profile
    -- 1.x exports still need the legacy migrations.
    if not isV2 then
        runMigrations(data)
        data.migrations = nil
    end
    local clean = {}
    for category, values in pairs(data) do
        local template = defaults.profile[category]
        if template ~= nil and type(values) == type(template) then
            clean[category] = type(values) == "table" and sanitizedCopy(values, template) or values
        end
    end
    -- Reset first so every default is present, then write the imported
    -- values into those tables (replacing them would drop missing defaults).
    self.db:ResetProfile(false, true)
    local function applyInto(dest, src)
        for key, value in pairs(src) do
            if type(value) == "table" and type(dest[key]) == "table" and not isList(value) then
                applyInto(dest[key], value)
            else
                dest[key] = value
            end
        end
    end
    applyInto(profile, clean)
    runMigrations(profile)
    self:OnProfileChanged()
end

-- Lifecycle -------------------------------------------------------------------
function SUI:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SUIDB", defaults, true)
    runMigrations(self.db.profile)

    local function changed()
        runMigrations(self.db.profile)
        self:OnProfileChanged()
    end
    self.db.RegisterCallback(self, "OnProfileChanged", changed)
    self.db.RegisterCallback(self, "OnProfileCopied", changed)
    self.db.RegisterCallback(self, "OnProfileReset", changed)

    self.Theme:Update()
end

function SUI:OnEnable()
    self:EnableFeatures()
    self.callbacks:Fire("Ready")
end

function SUI:OnProfileChanged()
    self.Theme:Update()
    self:ReevaluateFeatures()
    self:NotifyThemeChanged()
    self.callbacks:Fire("ProfileChanged")
end
