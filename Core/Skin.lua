--[[
    SUI 2.0 - Core/Skin.lua

    Tints Blizzard frames with the theme. Skins are data: an add-on name and
    a list of frame paths (or a function for special cases).

        SUI.Skin:Register("Blizzard_MacroUI", {
            "MacroFrame", "MacroFrame.NineSlice", "MacroFrameInset.NineSlice",
        })

    Frames of add-ons that are already loaded are skinned at login. Skins are
    applied only while a tinting theme is active; switching the theme later
    applies pending skins and repaints the rest.
]]

local _, ns = ...
local SUI = ns.SUI

local type, _G, select = type, _G, select

local Skin = {}
SUI.Skin = Skin

-- Regions that must keep their original colours (icons, portraits, art).
-- Names are checked directly; object entries are resolved once at login.
local forbiddenNames = {
    CalendarCreateEventIcon = true,
    FriendsFrameIcon = true,
    MacroFramePortrait = true,
    QuestFrameDetailPanelBg = true,
    StaticPopup1AlertIcon = true,
    StaticPopup2AlertIcon = true,
    StaticPopup3AlertIcon = true,
    PVPReadyDialogBackground = true,
    LFGDungeonReadyDialogBackground = true,
}
local forbidden = {}
Skin.forbidden = forbidden

-- Adds an object (e.g. a region fetched via GetRegions) to the exceptions.
function Skin:Protect(object)
    if object then
        forbidden[object] = true
    end
end

local function resolve(path)
    if type(path) ~= "string" then
        return path
    end
    local obj = _G
    for part in path:gmatch("[^%.]+") do
        obj = obj and obj[part]
        if obj == nil then
            return nil
        end
    end
    return obj
end
Skin.Resolve = resolve

local function isForbidden(region)
    if forbidden[region] then
        return true
    end
    local name = region.GetName and region:GetName()
    return name ~= nil and forbiddenNames[name] == true
end

-- Paints one texture.
function Skin:Texture(texture, useTheme, sub)
    if texture and not isForbidden(texture) then
        SUI.Theme:Paint(texture, useTheme, sub)
    end
end

-- Paints every texture region directly on a frame (children are not walked).
function Skin:Frame(frame, useTheme, sub)
    frame = resolve(frame)
    if not frame then
        return
    end
    if frame.GetObjectType and frame:GetObjectType() == "Texture" then
        return self:Texture(frame, useTheme, sub)
    end
    if not frame.GetRegions then
        return
    end
    for i = 1, select("#", frame:GetRegions()) do
        local region = select(i, frame:GetRegions())
        if region:GetObjectType() == "Texture" then
            self:Texture(region, useTheme, sub)
        end
    end
end

-- Applies a list of frame paths/objects.
function Skin:Apply(list, useTheme, sub)
    for i = 1, #list do
        self:Frame(list[i], useTheme, sub)
    end
end

-- Registered skins ------------------------------------------------------------------
local pending = {} -- array of { addon, spec, useTheme, applied }

local function applyEntry(entry)
    if entry.applied or not SUI.Theme.enabled or (entry.owner and not entry.owner.enabled) then
        return
    end
    entry.applied = true
    if type(entry.spec) == "function" then
        entry.spec(Skin)
    else
        Skin:Apply(entry.spec, entry.useTheme ~= false)
    end
end

-- addon: "SUI" (or nil) for frames that exist at login, else the load-on-demand add-on.
-- owner (optional): a feature; the skin is only applied while it is enabled.
function Skin:Register(addon, spec, useTheme, owner)
    local entry = { addon = addon, spec = spec, useTheme = useTheme, owner = owner }
    pending[#pending + 1] = entry
    if SUI.skinsReady then
        self:Activate(entry)
    end
end

function Skin:Activate(entry)
    if entry.addon and entry.addon ~= "SUI" then
        SUI:OnAddonLoaded(entry.addon, function()
            applyEntry(entry)
        end)
    else
        applyEntry(entry)
    end
end

SUI.callbacks.RegisterCallback(Skin, "Ready", function()
    if GossipFrame then
        Skin:Protect(select(3, GossipFrame:GetRegions()))
    end
    if DressUpFrame then
        Skin:Protect(select(3, DressUpFrame:GetRegions()))
    end
    for i = 1, (NUM_CHAT_WINDOWS or 10) do
        local box = _G["ChatFrame" .. i .. "EditBox"]
        if box then
            Skin:Protect(select(2, box:GetRegions()))
        end
    end
    if TradeFrame and TradeFrame.RecipientOverlay then
        Skin:Protect(select(1, TradeFrame.RecipientOverlay:GetRegions()))
    end
    if LFGListInviteDialog then
        Skin:Protect(select(4, LFGListInviteDialog:GetRegions()))
    end

    SUI.skinsReady = true
    for i = 1, #pending do
        Skin:Activate(pending[i])
    end
end)

SUI.callbacks.RegisterCallback(Skin, "ThemeChanged", function()
    if SUI.skinsReady and SUI.Theme.enabled then
        for i = 1, #pending do
            if not pending[i].applied then
                Skin:Activate(pending[i])
            end
        end
    end
end)
