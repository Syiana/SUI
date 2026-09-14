--[[
    SUI 2.0 - Features/Maps/Coords.lua

    Player and cursor coordinates on the world map, and player coordinates on
    the minimap. The world map updates ten times a second only while it is
    open; the minimap only while the player moves or is on a taxi. Positions
    are unavailable (or secret) in instances; the text then shows a dash.
]]

local _, ns = ...
local SUI = ns.SUI

local floor = math.floor
local CanAccess = SUI.Compat.CanAccess

-- Player position in percent on the best map, or nil.
local function playerPosition()
    local mapID = C_Map.GetBestMapForUnit("player")
    local position = mapID and C_Map.GetPlayerMapPosition(mapID, "player")
    if not position then
        return nil
    end
    local x, y = position:GetXY()
    if not (x and y) or not CanAccess(x) or not CanAccess(y) or (x == 0 and y == 0) then
        return nil
    end
    return floor(x * 100 + 0.5), floor(y * 100 + 0.5)
end

-- World map -------------------------------------------------------------------------------
local WorldCoords = SUI:NewFeature("Maps.WorldMapCoords", { category = "maps", toggle = "coords" })

local holder, playerText, mouseText
local playerLabel

local function updateWorldMap()
    local x, y = playerPosition()
    if x then
        playerText:SetFormattedText("%s: %d, %d", playerLabel, x, y)
    else
        playerText:SetFormattedText("%s: -", playerLabel)
    end
    local container = WorldMapFrame.ScrollContainer
    if container and container:IsMouseOver() and container.GetNormalizedCursorPosition then
        local cx, cy = container:GetNormalizedCursorPosition()
        if cx and cx >= 0 and cy >= 0 and cx <= 1 and cy <= 1 then
            mouseText:SetFormattedText("Mouse: %d, %d", floor(cx * 100 + 0.5), floor(cy * 100 + 0.5))
            return
        end
    end
    mouseText:SetText("")
end

local function startWorldMap()
    if WorldCoords.enabled and holder and WorldMapFrame:IsShown() then
        updateWorldMap()
        WorldCoords:StartUpdate(updateWorldMap, 0.1)
    end
end

function WorldCoords:OnLoad()
    playerLabel = UnitName("player") or PLAYER or "Player"
    SUI:OnAddonLoaded("Blizzard_WorldMap", function()
        local map = WorldMapFrame
        if not map or holder then
            return
        end
        local anchor = map.ScrollContainer or map
        holder = CreateFrame("Frame", nil, map)
        holder:SetAllPoints(anchor)
        holder:SetFrameLevel((map.BorderFrame or map):GetFrameLevel() + 2)
        playerText = holder:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        playerText:SetPoint("BOTTOM", anchor, "BOTTOM", 0, 20)
        mouseText = holder:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        mouseText:SetPoint("BOTTOM", playerText, "TOP", 0, 5)
        holder:SetShown(WorldCoords.enabled)
        map:HookScript("OnShow", startWorldMap)
        map:HookScript("OnHide", function()
            WorldCoords:StopUpdate()
        end)
        startWorldMap()
    end)
end

function WorldCoords:OnEnable()
    if holder then
        holder:Show()
        startWorldMap()
    end
end

function WorldCoords:OnDisable()
    if holder then
        holder:Hide()
    end
end

-- Minimap -------------------------------------------------------------------------------------
local MinimapCoords = SUI:NewFeature("Maps.MinimapCoords", {
    category = "maps",
    toggle = "minimapcoords",
    conflicts = { "SexyMap" },
})

local minimapText

local function updateMinimap()
    local x, y = playerPosition()
    if x then
        minimapText:SetFormattedText("%d, %d", x, y)
    else
        minimapText:SetText("-")
    end
end

function MinimapCoords:OnLoad()
    minimapText = Minimap:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    minimapText:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 12)
    minimapText:Hide()
end

function MinimapCoords:StartMoving()
    self:StartUpdate(updateMinimap, 0.2)
end

function MinimapCoords:StopMoving()
    self:StopUpdate()
    updateMinimap()
end

function MinimapCoords:Refresh()
    updateMinimap()
end

function MinimapCoords:OnEnable()
    minimapText:Show()
    updateMinimap()
    self:RegisterEvent("PLAYER_STARTED_MOVING", "StartMoving")
    self:RegisterEvent("PLAYER_STOPPED_MOVING", "StopMoving")
    self:RegisterEvent("PLAYER_CONTROL_LOST", "StartMoving")    -- taxi
    self:RegisterEvent("PLAYER_CONTROL_GAINED", "StopMoving")
    self:RegisterEvent("ZONE_CHANGED", "Refresh")
    self:RegisterEvent("ZONE_CHANGED_INDOORS", "Refresh")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Refresh")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "StopMoving")
end

function MinimapCoords:OnDisable()
    minimapText:Hide()
end
