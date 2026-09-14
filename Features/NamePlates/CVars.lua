--[[
    SUI 2.0 - Features/NamePlates/CVars.lua

    Nameplate console variables: size and stacking for the Custom style
    (as in 1.x) plus a few optional nameplate settings. Unknown CVars of a
    client are skipped, changes wait until combat ends, and CVars SUI set in
    this session go back to their defaults when the option is turned off.
]]

local _, ns = ...
local SUI = ns.SUI
local NP = ns.NamePlates

local next, wipe, tostring = next, wipe, tostring

local F = SUI:NewFeature("NamePlates.CVars", {
    category = "nameplates",
    toggle = function(db)
        return NP.isCustom(db) or db.cvars.enabled
    end,
    conflicts = NP.conflicts,
})

local desired = {} -- cvar -> value
local touched = {} -- cvars SUI changed this session
local queued = false

local function flag(value)
    return value and 1 or 0
end

local function collect(db)
    wipe(desired)
    if F.enabled and NP.isCustom(db) then
        desired.NamePlateVerticalScale = db.height
        desired.NamePlateHorizontalScale = db.width
        if db.stackingmode then
            if Enum and Enum.NamePlateStackType then
                desired.nameplateStackingTypes = bit.lshift(1, Enum.NamePlateStackType.Enemy - 1)
            else
                desired.nameplateMotion = 1
                desired.nameplateOverlapH = 0.5
                desired.nameplateOverlapV = 0.5
                desired.nameplateMinScale = 1
            end
        end
    end
    local cvars = db.cvars
    if F.enabled and cvars.enabled then
        desired.nameplateShowFriendlyNPCs = flag(cvars.friendlynpcs)
        if SUI.IsRetail then
            desired.nameplateShowOffscreen = flag(cvars.offscreen)
            desired.nameplateShowOnlyNames = flag(cvars.onlynames)
            desired.nameplateShowOnlyNameForFriendlyPlayerUnits = flag(cvars.onlynames)
        else
            desired.nameplateMaxDistance = cvars.maxdistance
        end
    end
end

local function apply()
    queued = false
    local Compat = SUI.Compat
    local getDefault = Compat.GetCVarDefault
    collect(F.db)
    for name, value in next, desired do
        if getDefault(name) ~= nil then
            value = tostring(value)
            if Compat.GetCVar(name) ~= value then
                Compat.SetCVar(name, value)
            end
            touched[name] = true
        end
    end
    for name in next, touched do
        if desired[name] == nil then
            Compat.SetCVar(name, getDefault(name))
            touched[name] = nil
        end
    end
end

local function queue()
    if not queued then
        queued = true
        SUI:RunAfterCombat(apply)
    end
end

F.OnEnable = queue
F.OnRefresh = queue
F.OnDisable = queue
