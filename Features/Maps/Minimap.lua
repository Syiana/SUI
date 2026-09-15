--[[
    SUI 2.0 - Features/Maps/Minimap.lua

    Minimap scale, square style, mouseover fade and the visibility of the
    Blizzard elements around it (clock, calendar, tracking, zone text,
    expansion button, add-on buttons). Frame names differ between retail
    (MinimapCluster.*) and classic (Minimap* globals), so every element is
    looked up with both. Nothing here runs while SexyMap owns the minimap.
]]

-- LibDBIcon and other minimap add-ons read this global to place buttons.
-- luacheck: globals GetMinimapShape

local _, ns = ...
local SUI = ns.SUI

local _G = _G

local SEXYMAP = { "SexyMap" }
local RETAIL = { Mainline = true }

-- Keeps a Blizzard element hidden while the feature runs. Blizzard shows some
-- of them again on its own, so OnShow hides them once more.
local function hider(id, key, resolve, addon, clients)
    local F = SUI:NewFeature(id, {
        category = "maps",
        conflicts = SEXYMAP,
        clients = clients,
        toggle = key and function(db)
            return not db[key]
        end,
    })

    function F:OnLoad()
        local feature = self
        SUI:OnAddonLoaded(addon or SUI.name, function()
            local frame = resolve()
            if not frame then
                return
            end
            feature.frame = frame
            if frame.HookScript then
                frame:HookScript("OnShow", function(f)
                    if feature.enabled then
                        f:Hide()
                    end
                end)
            end
            if feature.enabled then
                frame:Hide()
            end
        end)
    end

    function F:OnEnable()
        if self.frame then
            self.frame:Hide()
        end
    end

    function F:OnDisable()
        if self.frame then
            self.frame:Show()
        end
    end

    return F
end

local function cluster(key)
    local c = _G.MinimapCluster
    return c and c[key]
end

-- Base: scale and the bar above the minimap (hidden like in 1.x) ---------------------
local Base = hider("Maps.Minimap", nil, function()
    return cluster("BorderTop") or _G.MinimapBorderTop
end)

local function applyScale(feature)
    local size = feature.db.minimapsize
    if size ~= 1 or feature.scaled then
        Minimap:SetScale(size)
        feature.scaled = true
    end
end

local hideBorderTop = Base.OnEnable
function Base:OnEnable()
    hideBorderTop(self)
    applyScale(self)
end

function Base:OnRefresh(key)
    if key == "minimapsize" then
        applyScale(self)
    end
end

-- Element visibility ------------------------------------------------------------------
hider("Maps.HideMinimap", "minimap", function()
    return _G.MinimapCluster
end)

hider("Maps.Clock", "clock", function()
    return _G.TimeManagerClockButton
end, "Blizzard_TimeManager")

hider("Maps.Calendar", "date", function()
    return _G.GameTimeFrame
end)

hider("Maps.Tracking", "tracking", function()
    return cluster("Tracking") or _G.MiniMapTracking or _G.MiniMapTrackingFrame
end)

hider("Maps.ZoneText", "zonetext", function()
    return cluster("ZoneTextButton") or _G.MinimapZoneTextButton
end)

-- Expansion landing page button (retail) ----------------------------------------------------
local Expansion = SUI:NewFeature("Maps.ExpansionButton", {
    category = "maps",
    clients = RETAIL,
    conflicts = SEXYMAP,
    toggle = function(db)
        return not db.garrison or db.expansionbutton
    end,
})

function Expansion:OnLoad()
    local button = _G.ExpansionLandingPageMinimapButton
    if not button then
        return
    end
    self.button = button
    local feature = self
    -- 1.x hid the button 0.1s after the mouse left, so moving across it does not flicker.
    local function hideIfLeft()
        if not feature.hovered then
            button:SetAlpha(0)
        end
    end
    self:HookScript(button, "OnEnter", function(b)
        feature.hovered = true
        b:SetAlpha(1)
    end)
    self:HookScript(button, "OnLeave", function()
        feature.hovered = false
        feature:After(0.1, hideIfLeft)
    end)
end

function Expansion:OnEnable()
    if self.button then
        -- Hidden: invisible and not clickable. Mouseover: invisible until hovered.
        self.button:SetAlpha(0)
        self.button:EnableMouse(self.db.garrison)
    end
end

function Expansion:OnRefresh()
    self:OnEnable()
end

function Expansion:OnDisable()
    if self.button then
        self.button:SetAlpha(1)
        self.button:EnableMouse(true)
    end
end

-- Add-on buttons on mouseover (LibDBIcon) -----------------------------------------------------
-- Off while Maps.ButtonBar collects the buttons into its own bar.
local Buttons = SUI:NewFeature("Maps.AddonButtons", {
    category = "maps",
    toggle = function(db)
        return db.buttons and not db.buttonbar.enabled
    end,
    conflicts = SEXYMAP,
})

local LDBI = LibStub("LibDBIcon-1.0", true)

local function showOnEnter(value)
    local names = LDBI:GetButtonList()
    for i = 1, #names do
        LDBI:ShowOnEnter(names[i], value)
    end
end

function Buttons:OnLoad()
    if not LDBI then
        return
    end
    local feature = self
    LDBI.RegisterCallback(self, "LibDBIcon_IconCreated", function(_, _, name)
        if feature.enabled then
            LDBI:ShowOnEnter(name, true)
        end
    end)
end

function Buttons:OnEnable()
    if LDBI then
        showOnEnter(true)
    end
end

function Buttons:OnDisable()
    if LDBI then
        showOnEnter(false)
    end
end

-- Mouseover fade ---------------------------------------------------------------------------------
local Fade = SUI:NewFeature("Maps.MinimapFade", {
    category = "maps",
    toggle = "fade",
    conflicts = SEXYMAP,
})

local FADE_ALPHA = 0.3

-- Runs after the mouse left the minimap itself; buttons around it still count as inside.
local function fadeWhenOutside()
    if not MinimapCluster:IsMouseOver() then
        MinimapCluster:SetAlpha(FADE_ALPHA)
        Fade:StopUpdate()
    end
end

function Fade:OnLoad()
    self:HookScript(Minimap, "OnEnter", function()
        Fade:StopUpdate()
        MinimapCluster:SetAlpha(1)
    end)
    self:HookScript(Minimap, "OnLeave", function()
        Fade:StartUpdate(fadeWhenOutside, 0.25)
    end)
end

function Fade:OnEnable()
    if not MinimapCluster:IsMouseOver() then
        MinimapCluster:SetAlpha(FADE_ALPHA)
    end
end

function Fade:OnDisable()
    MinimapCluster:SetAlpha(1)
end

-- Square style -------------------------------------------------------------------------------------
local Square = SUI:NewFeature("Maps.MinimapStyle", {
    category = "maps",
    conflicts = SEXYMAP,
    toggle = function(db)
        return db.style == "Square"
    end,
})

local SQUARE_MASK = [[Interface\Buttons\WHITE8X8]]
local ROUND_MASK = SUI.IsRetail and [[Interface\Masks\CircleMaskScalable]] or [[Textures\MinimapMask]]
local HYBRID_ROUND_MASK = [[Interface\CharacterFrame\TempPortraitAlphaMask]]
local BORDER = 2

local border, edges
local previousShape
local function squareShape()
    return "SQUARE"
end

local function setHybridMask(mask)
    local hybrid = _G.HybridMinimap
    if hybrid and hybrid.CircleMask and hybrid.MapCanvas then
        hybrid.MapCanvas:SetUseMaskTexture(false)
        hybrid.CircleMask:SetTexture(mask)
        hybrid.MapCanvas:SetUseMaskTexture(true)
    end
end

-- Round art that makes no sense on a square map.
local function setRoundArt(alpha)
    local compass, ring = _G.MinimapCompassTexture, _G.MinimapBorder
    if compass then
        compass:SetAlpha(alpha)
    end
    if ring then
        ring:SetAlpha(alpha)
    end
end

local function paintBorder()
    local r, g, b = 0, 0, 0
    if SUI.Theme.enabled then
        r, g, b = SUI.Theme:Color(0.15)
    end
    for i = 1, #edges do
        edges[i]:SetVertexColor(r, g, b)
    end
end

function Square:OnLoad()
    border = CreateFrame("Frame", nil, Minimap)
    border:SetAllPoints(Minimap)
    border:Hide()
    -- Four edges outside the map; the horizontal ones also cover the corners.
    local function edge(p1, r1, x1, p2, r2, x2, horizontal)
        local t = border:CreateTexture(nil, "OVERLAY")
        t:SetColorTexture(1, 1, 1)
        t:SetPoint(p1, Minimap, r1, x1, 0)
        t:SetPoint(p2, Minimap, r2, x2, 0)
        if horizontal then
            t:SetHeight(BORDER)
        else
            t:SetWidth(BORDER)
        end
        return t
    end
    edges = {
        edge("BOTTOMLEFT", "TOPLEFT", -BORDER, "BOTTOMRIGHT", "TOPRIGHT", BORDER, true),
        edge("TOPLEFT", "BOTTOMLEFT", -BORDER, "TOPRIGHT", "BOTTOMRIGHT", BORDER, true),
        edge("TOPRIGHT", "TOPLEFT", 0, "BOTTOMRIGHT", "BOTTOMLEFT", 0),
        edge("TOPLEFT", "TOPRIGHT", 0, "BOTTOMLEFT", "BOTTOMRIGHT", 0),
    }

    local feature = self
    SUI:OnAddonLoaded("Blizzard_HybridMinimap", function()
        if feature.enabled then
            setHybridMask(SQUARE_MASK)
        end
    end)
end

function Square:OnEnable()
    Minimap:SetMaskTexture(SQUARE_MASK)
    setHybridMask(SQUARE_MASK)
    setRoundArt(0)
    paintBorder()
    border:Show()
    if GetMinimapShape ~= squareShape then
        previousShape = GetMinimapShape
        GetMinimapShape = squareShape
    end
end

function Square:OnDisable()
    Minimap:SetMaskTexture(ROUND_MASK)
    setHybridMask(HYBRID_ROUND_MASK)
    setRoundArt(1)
    border:Hide()
    if GetMinimapShape == squareShape then
        GetMinimapShape = previousShape
    end
end

function Square:OnThemeChanged()
    paintBorder()
end

-- Theme tint of the round minimap art (1.x skin) ---------------------------------------------------
SUI.Skin:Register("SUI", function(Skin)
    Skin:Apply({ "MinimapCompassTexture", "MinimapBorder", "MinimapBorderTop" }, true, 0.2)
end)

