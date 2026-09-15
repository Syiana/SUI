--[[
    SUI smoke test. Usage (from the addon root):
        luajit tools/smoke/run.lua Mainline|Mists|TBC|Vanilla [--ui]

    Loads the addon like the client would (TOC order), runs login, toggles
    every option through SUI:Set, switches profile and theme, fires common
    events and reports Lua errors plus option keys without defaults.
]]

-- Hooks do not fire inside JIT-compiled traces; the loop guard needs the interpreter.
if jit then jit.off() end
local CLIENT = arg[1] or "Mainline"
local BUILD_UI = arg[2] == "--ui"
local DUMP = arg[2] == "--dump"
local KEYS = arg[2] == "--keys" or arg[2] == "--values"
local VALUES = arg[2] == "--values"
package.path = "tools/smoke/?.lua;" .. package.path
local W = require("wow")
local mock = W.mock

local PROJECT = { Mainline = 1, Vanilla = 2, TBC = 5, Mists = 19 }
local INTERFACE = { Mainline = 120100, Mists = 50504, TBC = 20506, Vanilla = 11508 }
local isRetail = CLIENT == "Mainline"

-- Globals ---------------------------------------------------------------------------
local G = _G
local absent = {}
if not isRetail then
    for _, name in ipairs({
        "EditModeManagerFrame", "TooltipDataProcessor", "C_ChallengeMode", "C_MythicPlus", "C_PlayerInfo",
        "GetMouseFoci", "C_UnitAuras", "canaccessvalue", "issecretvalue", "C_ClassColor", "C_SpecializationInfo",
        "C_Spell", "C_Item", "C_ActionBar", "C_LFGList", "ScenarioObjectiveTracker", "C_Housing",
        "PlayerSpellsFrame", "ClassTalentFrame", "C_EditMode", "C_PvP", "Menu", "MenuUtil",
    }) do absent[name] = true end
end
if CLIENT == "Vanilla" or CLIENT == "TBC" then
    for _, name in ipairs({ "GetSpecialization", "FocusFrame", "C_PetBattles", "PetBattleFrame" }) do absent[name] = true end
end

setmetatable(G, {
    __index = function(_, k)
        if absent[k] then return nil end
        -- Numbered frame names (ChatFrame11, CompactRaidFrame3) are nil unless
        -- created, so "loop until nil" code terminates.
        if type(k) == "string" and k:match("%d$") then return nil end
        if type(k) == "string" and k:match("^[A-Z]") then
            local v = mock(k)
            rawset(G, k, v)
            return v
        end
        return nil
    end,
})

local printed = {}
G.print = function(...) printed[#printed + 1] = table.concat({ tostringall and tostringall(...) or ... }, " ") end
G.bit = require("bit")
G.format = string.format
G.strfind, G.strsub, G.strlower, G.strupper, G.strlen, G.strrep, G.gsub, G.strmatch, G.strbyte, G.strchar =
    string.find, string.sub, string.lower, string.upper, string.len, string.rep, string.gsub, string.match, string.byte, string.char
G.strlenutf8 = string.len
G.floor, G.ceil, G.abs, G.max, G.min, G.sqrt, G.random = math.floor, math.ceil, math.abs, math.max, math.min, math.sqrt, math.random
G.tinsert, G.tremove, G.sort = table.insert, table.remove, table.sort
G.date, G.time = os.date, os.time
G.debugstack = function() return "" end
G.debugprofilestop = function() return os.clock() * 1000 end
G.securecallfunction = function(f, ...) return f(...) end
G.geterrorhandler = function() return function(err) W.report("errorhandler", debug.traceback(err, 2)) end end
G.seterrorhandler = function() end
G.wipe = function(t) for k in pairs(t) do t[k] = nil end return t end
G.tContains = function(t, v) for _, x in pairs(t) do if x == v then return true end end return false end
G.strtrim = function(s, chars) s = s or ""; return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
G.strsplit = function(sep, str, limit)
    local out, start, n = {}, 1, 0
    str = tostring(str)
    while true do
        n = n + 1
        local a, b = str:find(sep, start, true)
        if not a or (limit and n >= limit) then out[#out + 1] = str:sub(start); break end
        out[#out + 1] = str:sub(start, a - 1)
        start = b + 1
    end
    return unpack(out)
end
string.trim, string.split, string.join = G.strtrim, function(s, sep, limit) return G.strsplit(sep, s, limit) end, nil
G.strjoin = function(sep, ...) return table.concat({ ... }, sep) end
G.tostringall = function(...) local t = { ... } for i = 1, select("#", ...) do t[i] = tostring(t[i]) end return unpack(t, 1, select("#", ...)) end
G.CopyTable = function(t) local c = {} for k, v in pairs(t) do c[k] = type(v) == "table" and G.CopyTable(v) or v end return c end
G.Mixin = function(o, ...) for i = 1, select("#", ...) do for k, v in pairs((select(i, ...))) do o[k] = v end end return o end
G.CreateFromMixins = function(...) return G.Mixin({}, ...) end
G.CreateColor = function(r, g, b, a) return { r = r, g = g, b = b, a = a, GetRGB = function(self) return self.r, self.g, self.b end } end
G.BackdropTemplateMixin = { SetBackdrop = function() end, SetBackdropColor = function() end, SetBackdropBorderColor = function() end }
G.hooksecurefunc = function(a, b, c)
    W.hooks = W.hooks + 1
    if type(a) == "string" then
        local orig = rawget(G, a)
        if type(orig) == "function" then rawset(G, a, function(...) local r = { orig(...) }; b(...); return unpack(r) end) end
    elseif type(a) == "table" and getmetatable(a) ~= nil and rawget(a, "__kind") then
        local orig = a[b]
        if type(orig) == "function" then a[b] = function(...) local r = { orig(...) }; c(...); return unpack(r) end end
    end
end
G.issecure = function() return false end
G.InCombatLockdown = function() return false end
G.GetTime = function() return os.clock() end
G.GetFramerate = function() return 60 end
G.GetNetStats = function() return 0, 0, 20, 30 end
G.GetBuildInfo = function() return "x", "1", "Sep 1 2026", INTERFACE[CLIENT] end
G.GetLocale = function() return "enUS" end
G.GetScreenWidth = function() return 1920 end
G.GetScreenHeight = function() return 1080 end
G.GetCursorPosition = function() return 0, 0 end
G.UnitClass = function() return "Warrior", "WARRIOR", 1 end
G.UnitName = function() return "Tester", nil end
G.UnitGUID = function() return "Player-1-00000001" end
G.UnitExists = function(u) return u == "player" end
G.UnitIsPlayer = function(u) return u == "player" end
G.UnitHealth = function() return 100 end
G.UnitHealthMax = function() return 100 end
G.UnitPower = function() return 50 end
G.UnitPowerMax = function() return 100 end
G.UnitLevel = function() return 80 end
G.UnitAffectingCombat = function() return false end
G.UnitReaction = function() return 4 end
G.UnitFactionGroup = function() return "Alliance", "Alliance" end
G.GetRealmName = function() return "Realm" end
G.GetNormalizedRealmName = function() return "Realm" end
G.IsInGroup, G.IsInRaid, G.IsInGuild, G.IsInInstance = function() return false end, function() return false end, function() return false end, function() return false, "none" end
G.GetNumGroupMembers = function() return 0 end
G.GetMaxBattlefieldID = function() return 2 end
-- Realistic "nothing there" answers for data APIs whose results get compared.
G.GetInventoryItemLink = function() return nil end
G.GetInventoryItemID = function() return nil end
G.GetContainerNumSlots = function() return 0 end
G.C_Container = { GetContainerNumSlots = function() return 0 end, GetContainerItemInfo = function() return nil end, GetContainerItemLink = function() return nil end, UseContainerItem = function() end }
G.C_Map = { GetBestMapForUnit = function() return 1 end, GetPlayerMapPosition = function() return nil end, GetMapInfo = function() return nil end }
G.NUM_TOTAL_EQUIPPED_BAG_SLOTS = 4
G.GetNumSubgroupMembers = function() return 0 end
G.GetNumBindings = function() return 0 end
G.GetMoney = function() return 0 end
G.ReloadUI = function() W.reloaded = true end
G.StaticPopupDialogs, G.UISpecialFrames, G.SlashCmdList, G.hash_SlashCmdList = {}, {}, {}, {}
G.StaticPopup_Show = function() end
G.UIFrameFade = function(frame, info) if info.finishedFunc then info.finishedFunc(frame) end end
G.UIFrameFadeIn = function() end
G.UIFrameFadeOut = function() end
G.NUM_CHAT_WINDOWS, G.NUM_ACTIONBAR_BUTTONS, G.MAX_BOSS_FRAMES, G.NUM_BAG_SLOTS = 10, 12, 5, 4
G.STANDARD_TEXT_FONT, G.UNIT_NAME_FONT, G.DAMAGE_TEXT_FONT = "Fonts\\FRIZQT__.TTF", "Fonts\\FRIZQT__.TTF", "Fonts\\FRIZQT__.TTF"
G.RAID_CLASS_COLORS = setmetatable({}, { __index = function() return { r = 1, g = 1, b = 1, colorStr = "ffffffff", GetRGB = function() return 1, 1, 1 end } end })
G.WOW_PROJECT_ID = PROJECT[CLIENT]
G.WOW_PROJECT_MAINLINE, G.WOW_PROJECT_CLASSIC, G.WOW_PROJECT_BURNING_CRUSADE_CLASSIC, G.WOW_PROJECT_MISTS_CLASSIC = 1, 2, 5, 19
G.CreateFrame = W.CreateFrame
G.UIParent = W.CreateFrame("Frame", "UIParent")
G.WorldFrame = W.CreateFrame("Frame", "WorldFrame")
G.GameTooltip = W.CreateFrame("GameTooltip", "GameTooltip", G.UIParent)
G.Minimap = W.CreateFrame("Minimap", "Minimap", G.UIParent)
G.WorldMapFrame = W.CreateFrame("Frame", "WorldMapFrame", G.UIParent)
G.WorldMapFrame.ScrollContainer = W.CreateFrame("ScrollFrame", nil, G.WorldMapFrame)
G.ChatFrame1 = W.CreateFrame("ScrollingMessageFrame", "ChatFrame1", G.UIParent)
G.DEFAULT_CHAT_FRAME = G.ChatFrame1
for i = 1, 10 do W.CreateFrame("EditBox", "ChatFrame" .. i .. "EditBox", G.UIParent) end
local loadedAddons = { SUI = true }
local function isLoaded(name) return loadedAddons[name] == true end
G.IsAddOnLoaded = isLoaded
G.C_AddOns = { IsAddOnLoaded = isLoaded, GetAddOnMetadata = function() return "2.0.0" end, DisableAddOn = function() end, EnableAddOn = function() end, LoadAddOn = function() end, GetAddOnEnableState = function() return 2 end }
local timers = {}
G.C_Timer = {
    After = function(_, fn) timers[#timers + 1] = fn end,
    NewTimer = function(_, fn) timers[#timers + 1] = fn; return { Cancel = function() end, IsCancelled = function() return false end } end,
    NewTicker = function(_, fn) timers[#timers + 1] = fn; return { Cancel = function() end, IsCancelled = function() return false end } end,
}
local function runTimers()
    for _ = 1, 3 do
        local list = timers
        timers = {}
        for _, fn in ipairs(list) do
            local ok, err = xpcall(fn, debug.traceback)
            if not ok then W.report("timer", err) end
        end
    end
end
if isRetail then
    G.canaccessvalue = function() return true end
    G.issecretvalue = function() return false end
    G.EditModeManagerFrame = W.CreateFrame("Frame", "EditModeManagerFrame", G.UIParent)
end

-- Libraries -------------------------------------------------------------------------
local LibStub = { libs = {}, minors = {} }
function LibStub:NewLibrary(major, minor)
    minor = tonumber(tostring(minor):match("%d+")) or 0
    local old = self.minors[major]
    if old and old >= minor then return nil end
    self.minors[major] = minor
    self.libs[major] = self.libs[major] or {}
    return self.libs[major], old
end
function LibStub:GetLibrary(major, silent)
    if not self.libs[major] and not silent then error("Cannot find a library instance of " .. tostring(major), 2) end
    return self.libs[major], self.minors[major]
end
setmetatable(LibStub, { __call = LibStub.GetLibrary })
G.LibStub = LibStub

local CH = LibStub:NewLibrary("CallbackHandler-1.0", 1)
function CH:New(target, RegisterName, UnregisterName, UnregisterAllName)
    RegisterName = RegisterName or "RegisterCallback"
    UnregisterName = UnregisterName or "UnregisterCallback"
    if UnregisterAllName == nil then UnregisterAllName = "UnregisterAllCallbacks" end
    local events = {}
    local registry = { events = events }
    function registry:Fire(event, ...)
        local e = events[event]
        if not e then return end
        local copy = {}
        for k, v in pairs(e) do copy[k] = v end
        for _, fn in pairs(copy) do
            local ok, err = xpcall(fn, debug.traceback, event, ...)
            if not ok then W.report("callback " .. event, err) end
        end
    end
    target[RegisterName] = function(self, event, method)
        local fn
        if type(method) == "string" then
            fn = function(...) return self[method](self, ...) end
        elseif type(method) == "function" then
            fn = method
        else
            fn = function(...) return self[event](self, ...) end
        end
        events[event] = events[event] or {}
        events[event][self] = fn
    end
    target[UnregisterName] = function(self, event) if events[event] then events[event][self] = nil end end
    if UnregisterAllName then
        target[UnregisterAllName] = function(self) for _, e in pairs(events) do e[self] = nil end end
    end
    return registry
end

local addons = {}
local AceAddon = LibStub:NewLibrary("AceAddon-3.0", 1)
local mixins = {}
mixins["AceEvent-3.0"] = function(obj)
    local frame = W.CreateFrame("Frame")
    local handlers = {}
    frame:SetScript("OnEvent", function(_, event, ...)
        local h = handlers[event]
        if type(h) == "function" then h(event, ...) elseif type(h) == "string" then obj[h](obj, event, ...) end
    end)
    function obj:RegisterEvent(event, handler) handlers[event] = handler or event; frame:RegisterEvent(event) end
    function obj:UnregisterEvent(event) handlers[event] = nil; frame:UnregisterEvent(event) end
    function obj:RegisterMessage() end
    function obj:SendMessage() end
end
mixins["AceComm-3.0"] = function(obj)
    function obj:RegisterComm() end
    function obj:SendCommMessage() W.commSent = true end
end
local serialized = {}
mixins["AceSerializer-3.0"] = function(obj)
    function obj:Serialize(v) serialized[#serialized + 1] = G.CopyTable(v); return "S" .. #serialized end
    function obj:Deserialize(s) local t = serialized[tonumber(tostring(s):sub(2)) or 0]; return t ~= nil, t and G.CopyTable(t) end
end
mixins["AceConsole-3.0"] = function(obj)
    function obj:RegisterChatCommand(cmd, fn) G.SlashCmdList[cmd] = fn end
    function obj:UnregisterChatCommand(cmd) G.SlashCmdList[cmd] = nil end
    function obj:Print() end
end
function AceAddon:NewAddon(name, ...)
    local obj = { name = name }
    for i = 1, select("#", ...) do mixins[select(i, ...)](obj) end
    addons[#addons + 1] = obj
    return obj
end

local function copyDefaults(dest, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            if type(dest[k]) ~= "table" then dest[k] = {} end
            copyDefaults(dest[k], v)
        elseif dest[k] == nil then
            dest[k] = v
        end
    end
end
local AceDB = LibStub:NewLibrary("AceDB-3.0", 1)
function AceDB:New(_, defaults)
    local db = { profiles = {}, current = "Default" }
    local cb = CH:New(db, "RegisterCallback", "UnregisterCallback", "UnregisterAllCallbacks")
    local function profile(name)
        if not db.profiles[name] then
            db.profiles[name] = {}
            copyDefaults(db.profiles[name], defaults.profile or {})
        end
        return db.profiles[name]
    end
    db.profile = profile("Default")
    db.global = {}; copyDefaults(db.global, defaults.global or {})
    db.char = {}; copyDefaults(db.char, defaults.char or {})
    function db:GetCurrentProfile() return self.current end
    function db:GetProfiles() local t = {} for k in pairs(self.profiles) do t[#t + 1] = k end table.sort(t) return t end
    function db:SetProfile(name) self.current = name; self.profile = profile(name); cb:Fire("OnProfileChanged", self, name) end
    function db:ResetProfile(_, noCallbacks)
        for k in pairs(self.profile) do self.profile[k] = nil end
        copyDefaults(self.profile, defaults.profile or {})
        if not noCallbacks then cb:Fire("OnProfileReset", self) end
    end
    function db:CopyProfile(name) local src = profile(name); for k in pairs(self.profile) do self.profile[k] = nil end; for k, v in pairs(G.CopyTable(src)) do self.profile[k] = v end; cb:Fire("OnProfileCopied", self, name) end
    function db:DeleteProfile(name) self.profiles[name] = nil end
    return db
end

local LSM = LibStub:NewLibrary("LibSharedMedia-3.0", 1)
LSM.LOCALE_BIT_western, LSM.LOCALE_BIT_ruRU = 1, 2
local media = {}
function LSM:Register(kind, name, path) media[kind] = media[kind] or {}; media[kind][name] = path; return true end
function LSM:List(kind) local t = {} for k in pairs(media[kind] or {}) do t[#t + 1] = k end table.sort(t) return t end
function LSM:HashTable(kind) return media[kind] or {} end
function LSM:Fetch(kind, name) return (media[kind] or {})[name] end
function LSM:IsValid(kind, name) return (media[kind] or {})[name] ~= nil end
function LSM:RegisterCallback() end

local LibDeflate = LibStub:NewLibrary("LibDeflate", 1)
function LibDeflate:CompressDeflate(s) return s end
LibDeflate.CompressZlib, LibDeflate.DecompressZlib, LibDeflate.DecompressDeflate = LibDeflate.CompressDeflate, LibDeflate.CompressDeflate, LibDeflate.CompressDeflate
LibDeflate.EncodeForPrint, LibDeflate.DecodeForPrint = LibDeflate.CompressDeflate, LibDeflate.CompressDeflate

if isRetail then
    local LEM = LibStub:NewLibrary("LibEditMode", 1)
    LEM.SettingType = { Slider = 1, Checkbox = 2, Dropdown = 3, ColorPicker = 4 }
    function LEM:AddFrame() end
    function LEM:AddFrameSettings() end
    function LEM:AddFrameSettingsButton() end
    function LEM:RegisterCallback() end
    function LEM:GetActiveLayoutName() return "Modern" end
    function LEM:IsInEditMode() return false end
end
do
    local icon = LibStub:NewLibrary("LibDBIcon-1.0", 1)
    icon.objects = {}
    function icon:GetButtonList() return {} end
    function icon:GetMinimapButton() return nil end
    function icon:Register() end
    function icon:Hide() end
    function icon:Show() end
    function icon:RegisterCallback() end
end
for _, name in ipairs({ "LibCustomGlow-1.0", "LibNPCInfo", "LibDataBroker-1.1" }) do
    local lib = LibStub:NewLibrary(name, 1)
    setmetatable(lib, { __index = function(t, k) local v = function() return nil end; rawset(t, k, v); return v end })
end

-- Loader ------------------------------------------------------------------------------
local ns = {}
local loaded = {}
local function exists(path) local f = io.open(path, "r"); if f then f:close() return true end return false end

local function loadLua(path)
    local chunk, err = loadfile(path)
    if not chunk then W.report("syntax " .. path, err); return end
    local ok, e = xpcall(chunk, debug.traceback, "SUI", ns)
    if not ok then W.report("load " .. path, e) end
    loaded[#loaded + 1] = path
end

local function loadXml(path)
    local f = io.open(path, "r")
    if not f then W.report("missing", "file not found: " .. path); return end
    local text = f:read("*a"); f:close()
    local dir = path:match("^(.*)/[^/]*$") or "."
    for tag, file in text:gmatch("<(%a+)%s+file%s*=%s*[\"']([^\"']+)[\"']") do
        local full = dir .. "/" .. file:gsub("\\", "/")
        if tag == "Include" or tag == "Script" then
            local isLib = full:match("^Libs/") and not full:match("^Libs/SUIConfig")
            if not isLib then
                if full:match("%.xml$") then loadXml(full) else
                    if exists(full) then loadLua(full) else W.report("missing", "file not found: " .. full) end
                end
            end
        end
    end
end

local toc = io.open("SUI_" .. CLIENT .. ".toc", "r")
for line in toc:lines() do
    line = line:gsub("\r", "")
    if line ~= "" and not line:match("^#") then
        local path = line:gsub("\\", "/")
        if path:match("%.xml$") then loadXml(path) else loadLua(path) end
    end
end
toc:close()

local SUI = ns.SUI
assert(SUI, "SUI namespace missing after load")

-- Lifecycle ------------------------------------------------------------------------------
local function step(name, fn)
    local count = 0
    debug.sethook(function()
        count = count + 1
        if count > 2000 then debug.sethook(); error("possible infinite loop (instruction limit)") end
    end, "", 100000)
    local ok, err = xpcall(fn, debug.traceback)
    debug.sethook()
    if not ok then W.report(name, err) end
end

step("OnInitialize", function() for _, a in ipairs(addons) do if a.OnInitialize then a:OnInitialize() end end end)
W.fire("ADDON_LOADED", "SUI")
step("OnEnable", function() for _, a in ipairs(addons) do if a.OnEnable then a:OnEnable() end end end)
W.fire("PLAYER_LOGIN")
W.fire("PLAYER_ENTERING_WORLD", true, false)
runTimers()
W.tickUpdates(0.5)

-- Blizzard load-on-demand add-ons referenced anywhere in Features.
local lod = {}
local p = io.popen("grep -rhoE 'Blizzard_[A-Za-z_]+' Features 2>/dev/null | sort -u")
for name in p:lines() do lod[#lod + 1] = name end
p:close()
for _, name in ipairs(lod) do
    loadedAddons[name] = true
    W.fire("ADDON_LOADED", name)
end
runTimers()

-- Options: keys must have defaults; every value must apply without errors.
local BINDABLE = { checkbox = true, dropdown = true, slider = true, sliderWithBox = true, editBox = true, color = true }
local missing, toggled = {}, 0
for _, spec in ipairs(SUI.Config.layouts) do
    if SUI:SupportsClient(spec.clients) and spec.bind ~= false then
        local ok, rows = xpcall(function() return type(spec.rows) == "function" and spec.rows() or spec.rows end, debug.traceback)
        if not ok then W.report("rows " .. spec.name, rows) rows = {} end
        for _, row in ipairs(rows or {}) do
            for rowKey, el in pairs(row) do
                if type(el) == "table" and BINDABLE[el.type] and not el.onValueChanged and SUI:SupportsClient(el.clients) then
                    local key = el.key or rowKey
                    local path = spec.category and (spec.category .. "." .. key) or key
                    local current = SUI:Get(path)
                    if current == nil then
                        missing[#missing + 1] = spec.name .. ": " .. path
                    else
                        local values = {}
                        if el.type == "checkbox" then values = { not current }
                        elseif el.type == "dropdown" and type(el.options) == "table" then
                            for _, o in ipairs(el.options) do values[#values + 1] = o.value end
                        elseif el.type == "slider" or el.type == "sliderWithBox" then values = { el.min or 0, el.max or 1 }
                        elseif el.type == "color" then values = { { r = 1, g = 0, b = 0, a = 1 } }
                        elseif el.type == "editBox" then values = { "smoke" } end
                        values[#values + 1] = current
                        for _, v in ipairs(values) do
                            step("Set " .. path, function() SUI:Set(path, v) end)
                            toggled = toggled + 1
                        end
                    end
                end
            end
        end
    end
end
runTimers()

-- Common events with plausible arguments.
local EVENTS = {
    { "PLAYER_TARGET_CHANGED" }, { "PLAYER_FOCUS_CHANGED" }, { "UNIT_HEALTH", "target" }, { "UNIT_AURA", "player" },
    { "GROUP_ROSTER_UPDATE" }, { "ZONE_CHANGED_NEW_AREA" }, { "MERCHANT_SHOW" }, { "NAME_PLATE_UNIT_ADDED", "nameplate1" },
    { "NAME_PLATE_UNIT_REMOVED", "nameplate1" }, { "PLAYER_REGEN_DISABLED" }, { "PLAYER_REGEN_ENABLED" },
    { "UPDATE_MOUSEOVER_UNIT" }, { "ACTIONBAR_SLOT_CHANGED", 1 }, { "ACTION_RANGE_CHECK_UPDATE", 1, true, true },
    { "UNIT_SPELLCAST_START", "target" }, { "UNIT_SPELLCAST_STOP", "target" }, { "CHAT_MSG_WHISPER", "hi", "Someone-Realm" },
    { "PLAYER_EQUIPMENT_CHANGED", 1 }, { "BAG_UPDATE_DELAYED" }, { "UPDATE_BATTLEFIELD_STATUS", 1 }, { "LOOT_READY", false },
    { "DUEL_REQUESTED", "Someone" }, { "PARTY_INVITE_REQUEST", "Someone" }, { "CINEMATIC_START" }, { "PLAYER_DEAD" },
    { "RESURRECT_REQUEST", "Someone" }, { "LFG_ROLE_CHECK_SHOW" }, { "QUEST_DETAIL" }, { "GOSSIP_SHOW" }, { "PLAYER_FLAGS_CHANGED", "player" },
    { "UI_ERROR_MESSAGE", 1, "error" }, { "INSPECT_READY", "Player-1-2" }, { "UNIT_POWER_UPDATE", "player", "MANA" },
    { "PLAYER_UPDATE_RESTING" }, { "CHAT_MSG_CHANNEL", "http://example.com", "Someone" }, { "UPDATE_CHAT_WINDOWS" },
}
for _, e in ipairs(EVENTS) do W.fire(unpack(e)) end
runTimers()
for _ = 1, 3 do W.tickUpdates(0.25) end

-- Theme and profile switching.
step("theme Blizzard", function() SUI:Set("general.theme", "Blizzard") end)
step("theme Class", function() SUI:Set("general.theme", "Class") end)
step("theme Dark", function() SUI:Set("general.theme", "Dark") end)
step("profile switch", function() SUI.db:SetProfile("Smoke"); SUI.db:SetProfile("Default") end)
step("profile reset", function() SUI.db:ResetProfile() end)
step("export/import", function()
    local s = SUI:ExportProfile()
    local data, v2 = SUI:DecodeProfile(s)
    assert(data, v2)
    SUI:ImportProfile(data, v2)
end)
runTimers()

if KEYS then
    -- Prints every default profile key path (for 1.x parity checks).
    local out = {}
    local function walk(tbl, prefix)
        if tbl[1] ~= nil then out[#out + 1] = prefix return end
        for k, v in pairs(tbl) do
            local p = prefix == "" and tostring(k) or (prefix .. "." .. tostring(k))
            if type(v) == "table" and next(v) ~= nil then walk(v, p) else out[#out + 1] = p .. (VALUES and (" = " .. tostring(v)) or "") end
        end
    end
    for category in pairs(SUI.db.profile) do
        local d = SUI:GetDefaults(category)
        if type(d) == "table" then walk(d, category) elseif d ~= nil then out[#out + 1] = category end
    end
    table.sort(out)
    io.stdout:write(table.concat(out, "\n"), "\n")
    os.exit(0)
end

if DUMP then
    -- Prints every tab with its sections and options (for menu reviews).
    local out = io.stdout
    for _, spec in ipairs(SUI.Config.layouts) do
        if SUI:SupportsClient(spec.clients) then
            out:write(("\n## %s (order %s, category %s)\n"):format(spec.title, tostring(spec.order), tostring(spec.category)))
            local rows = type(spec.rows) == "function" and spec.rows() or spec.rows
            for _, row in ipairs(rows or {}) do
                local items = {}
                for k, el in pairs(row) do items[#items + 1] = { k = k, el = el } end
                table.sort(items, function(a, b) return (a.el.order or 0) < (b.el.order or 0) end)
                local line = {}
                for _, it in ipairs(items) do
                    local el = it.el
                    if el.type == "header" then
                        if SUI:SupportsClient(el.clients) then out:write("  # " .. tostring(el.label) .. "\n") end
                    elseif SUI:SupportsClient(el.clients) then
                        line[#line + 1] = ("%s[%s%s]"):format(tostring(el.label or el.text or it.k), el.type, el.column and (":" .. el.column) or "")
                    end
                end
                if #line > 0 then out:write("    " .. table.concat(line, " | ") .. "\n") end
            end
        end
    end
    os.exit(0)
end

if BUILD_UI then
    step("config open", function() SUI.Config:Open() end)
    for _, spec in ipairs(SUI.Config.layouts) do
        step("config tab " .. spec.name, function() SUI.Config:Open(spec.name) end)
        step("config rebuild " .. spec.name, function() SUI.Config:RebuildCurrent() end)
        runTimers()
        if spec.category and SUI:GetDefaults(spec.category) then
            step("config reset " .. spec.name, function() SUI:ResetCategory(spec.category) end)
        end
    end
    step("config search", function() SUI.Config:RebuildTabs("font"); SUI.Config:RebuildTabs("") end)
    runTimers()
end

-- Report ------------------------------------------------------------------------------
local enabled, total, unsupported = 0, 0, 0
for _, f in pairs(SUI.features) do
    total = total + 1
    if f.unsupported then unsupported = unsupported + 1 elseif f.enabled then enabled = enabled + 1 end
end
print = io.write
io.write(("== %s: %d files, %d features (%d enabled, %d not for this client), %d option changes, %d hooks\n")
    :format(CLIENT, #loaded, total, enabled, unsupported, toggled, W.hooks))
if #missing > 0 then
    io.write(("-- %d option keys without a default:\n"):format(#missing))
    for _, m in ipairs(missing) do io.write("   " .. m .. "\n") end
end
io.write(("-- %d distinct errors\n"):format(#W.errors))
for _, key in ipairs(W.errors) do
    local e = W.errors[key]
    io.write(("\n[%s] x%d\n%s\n"):format(e.where, e.count, tostring(e.err):gsub("\n%s*%[C%]: in function 'xpcall'.*", "")))
end
os.exit((#W.errors > 0 or #missing > 0) and 1 or 0)
