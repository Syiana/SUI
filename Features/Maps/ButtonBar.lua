--[[
    SUI 2.0 - Features/Maps/ButtonBar.lua

    Collects add-on minimap buttons (LibDBIcon and others parented to the
    minimap) into a movable bar that is always shown, opened from a drawer
    button, or shown while the mouse is over the minimap. Buttons are found
    by scanning the minimap's children after login and shortly after add-ons
    load; there is no polling. Turning it off puts every button back where it
    was. Blizzard's own minimap buttons are never taken.
]]

local _, ns = ...
local SUI = ns.SUI

local _G, next, select, floor, ceil, max = _G, next, select, math.floor, math.ceil, math.max
local strfind = string.find
local CanAccess = SUI.Compat.CanAccess

local F = SUI:NewFeature("Maps.ButtonBar", {
    category = "maps",
    toggle = "buttonbar.enabled",
    conflicts = { "SexyMap" },
})

local LDBI = LibStub("LibDBIcon-1.0", true)

-- Named Blizzard frames around the minimap. Names starting with Minimap,
-- MiniMap or Queue are skipped as well; unnamed frames are never taken.
local BLIZZARD = {
    GameTimeFrame = true, TimeManagerClockButton = true, ExpansionLandingPageMinimapButton = true,
    GarrisonLandingPageMinimapButton = true, LFGMinimapFrame = true, AddonCompartmentFrame = true,
    HybridMinimap = true, GuildInstanceDifficulty = true, BattlefieldMinimap = true,
}
local PAD = 4

local bar, drawer
local list = {}      -- collected buttons in collection order
local original = {}  -- button -> { parent, scale, width, points }
local hooked = {}    -- buttons whose SetPoint/OnShow/OnHide are hooked (hooks cannot be removed)
local laidOut = {}   -- button -> shown state at the last layout
local inLayout, layoutPending, scanPending = false, false, false

-- Layout ----------------------------------------------------------------------------------
local function layout()
    layoutPending = false
    if not F.enabled then
        return
    end
    local db = F.db.buttonbar
    local size, spacing, grow = db.size, db.spacing, db.grow
    local perRow = max(1, db.perrow)
    local step = size + spacing
    local vertical = grow == "DOWN" or grow == "UP"
    local anchor = grow == "LEFT" and "TOPRIGHT" or grow == "UP" and "BOTTOMLEFT" or "TOPLEFT"
    local sx = grow == "LEFT" and -1 or 1
    local sy = grow == "UP" and 1 or -1
    local n = 0
    inLayout = true
    for i = 1, #list do
        local button = list[i]
        local shown = button:IsShown()
        laidOut[button] = shown
        if shown then
            local along, across = n % perRow, floor(n / perRow)
            local col, row = along, across
            if vertical then
                col, row = across, along
            end
            local scale = size / original[button].width
            button:SetScale(scale)
            button:ClearAllPoints()
            button:SetPoint(anchor, bar, anchor, sx * (PAD + col * step) / scale, sy * (PAD + row * step) / scale)
            n = n + 1
        end
    end
    inLayout = false
    local lines, count = ceil(n / perRow), n < perRow and n or perRow
    local cols, rows = count, lines
    if vertical then
        cols, rows = lines, count
    end
    bar:SetSize(max(1, cols) * step - spacing + 2 * PAD, max(1, rows) * step - spacing + 2 * PAD)
end

local function requestLayout()
    if not layoutPending then
        layoutPending = true
        F:After(0, layout)
    end
end

-- Another add-on (or LibDBIcon dragging) moved a collected button: put it back.
local function onSetPoint(button)
    if F.enabled and not inLayout and original[button] then
        requestLayout()
    end
end

local function onVisibility(button)
    if F.enabled and original[button] and laidOut[button] ~= button:IsShown() then
        requestLayout()
    end
end

-- Collecting ----------------------------------------------------------------------------------
local function isCandidate(frame)
    if original[frame] or frame == bar or frame == drawer or (frame.IsForbidden and frame:IsForbidden()) then
        return false
    end
    local name = frame:GetName()
    if not name or not CanAccess(name) then
        return false
    end
    if strfind(name, "^LibDBIcon10_") then
        return true
    end
    if BLIZZARD[name] or strfind(name, "^Mini[Mm]ap") or strfind(name, "^Queue") or frame:IsProtected() then
        return false
    end
    local kind = frame:GetObjectType()
    if kind ~= "Button" and not (kind == "Frame" and frame:GetScript("OnMouseUp")) then
        return false
    end
    local width, height = frame:GetSize()
    return width >= 10 and width <= 64 and height >= 10 and height <= 64
end

local function collect(button)
    local points = {}
    for i = 1, button:GetNumPoints() do
        points[i] = { button:GetPoint(i) }
    end
    local width = button:GetWidth()
    original[button] = {
        parent = button:GetParent(),
        scale = button:GetScale(),
        width = width > 0 and width or 31,
        points = points,
    }
    list[#list + 1] = button
    if not hooked[button] then
        hooked[button] = true
        hooksecurefunc(button, "SetPoint", onSetPoint)
        button:HookScript("OnShow", onVisibility)
        button:HookScript("OnHide", onVisibility)
    end
    button:SetParent(bar)
end

local function scanChildren(parent)
    if not parent then
        return
    end
    for i = 1, select("#", parent:GetChildren()) do
        local child = select(i, parent:GetChildren())
        if isCandidate(child) then
            collect(child)
        end
    end
end

local function scan()
    scanPending = false
    if not F.enabled then
        return
    end
    local before = #list
    if LDBI then
        for _, button in next, LDBI.objects do
            if isCandidate(button) then
                collect(button)
            end
        end
    end
    scanChildren(Minimap)
    scanChildren(_G.MinimapBackdrop)
    scanChildren(_G.MinimapCluster)
    if #list ~= before then
        layout()
    end
end

local function requestScan()
    if not scanPending then
        scanPending = true
        F:After(1, scan)
    end
end

local function release()
    for i = #list, 1, -1 do
        local button = list[i]
        local o = original[button]
        original[button], laidOut[button], list[i] = nil, nil, nil
        button:SetParent(o.parent)
        button:SetScale(o.scale)
        button:ClearAllPoints()
        for p = 1, #o.points do
            local point = o.points[p]
            button:SetPoint(point[1], point[2], point[3], point[4], point[5])
        end
    end
end

-- Modes ----------------------------------------------------------------------------------------
local function hideWhenOutside()
    if not (Minimap:IsMouseOver() or bar:IsMouseOver()) then
        bar:Hide()
        F:StopUpdate()
    end
end

local function applyMode()
    local mode = F.db.buttonbar.mode
    F:StopUpdate()
    drawer:SetShown(mode == "drawer")
    bar:SetShown(mode == "always")
end

function F:OnLoad()
    bar = CreateFrame("Frame", nil, UIParent)
    bar:SetSize(40, 40)
    bar:SetFrameStrata("MEDIUM")
    bar:EnableMouse(true)
    bar:Hide()
    local bg = bar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0.35)
    SUI.Movers:Add(bar, "minimapbuttons", { point = "TOPRIGHT", x = -10, y = -230 }, { label = "Minimap Buttons" })

    local feature = self
    bar:SetScript("OnEnter", function()
        if feature.db.buttonbar.mode == "mouseover" then
            feature:StopUpdate()
        end
    end)
    bar:SetScript("OnLeave", function()
        if feature.db.buttonbar.mode == "mouseover" then
            feature:StartUpdate(hideWhenOutside, 0.25)
        end
    end)

    drawer = CreateFrame("Button", nil, Minimap)
    drawer:SetSize(18, 18)
    drawer:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 2, 2)
    drawer:SetNormalTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]])
    drawer:SetPushedTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]])
    drawer:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]], "ADD")
    drawer:Hide()
    drawer:SetScript("OnClick", function()
        bar:SetShown(not bar:IsShown())
    end)
    drawer:SetScript("OnEnter", function(button)
        GameTooltip:SetOwner(button, "ANCHOR_LEFT")
        GameTooltip:SetText("Minimap Buttons")
        GameTooltip:Show()
    end)
    drawer:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    self:HookScript(Minimap, "OnEnter", function()
        if feature.db.buttonbar.mode == "mouseover" then
            feature:StopUpdate()
            bar:Show()
        end
    end)
    self:HookScript(Minimap, "OnLeave", function()
        if feature.db.buttonbar.mode == "mouseover" then
            feature:StartUpdate(hideWhenOutside, 0.25)
        end
    end)

    if LDBI then
        LDBI.RegisterCallback(self, "LibDBIcon_IconCreated", function()
            if feature.enabled then
                requestScan()
            end
        end)
    end
end

function F:OnEnable()
    applyMode()
    scan()
    layout()
    -- Many add-ons create their button a moment after login.
    self:After(3, scan)
    self:RegisterEvent("ADDON_LOADED", requestScan)
end

function F:OnRefresh(key)
    if key == nil or strfind(key, "^buttonbar%.") then
        applyMode()
        layout()
    end
end

function F:OnDisable()
    release()
    bar:Hide()
    drawer:Hide()
end
