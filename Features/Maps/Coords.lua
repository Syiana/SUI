--[[
    SUI 2.0 - Features/Maps/Coords.lua

    Player and cursor coordinates on the world map, and player coordinates on
    the minimap. The world map updates ten times a second only while it is
    open; the minimap only while the player moves or is on a taxi. Positions
    are unavailable (or secret) in instances. The world map text follows 1.x:
    "Name: x,y" and "Mouse: x,y", left-justified above the map's bottom edge.
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
    if not (x and y) or not CanAccess(x) or not CanAccess(y) then
        return nil
    end
    x, y = floor(100 * x), floor(100 * y)
    if x == 0 or y == 0 then
        return nil
    end
    return x, y
end

-- World map -------------------------------------------------------------------------------
local WorldCoords = SUI:NewFeature("Maps.WorldMapCoords", { category = "maps", toggle = "coords" })

local holder, playerText, mouseText
local playerLabel

local function updateWorldMap()
    local x, y = playerPosition()
    if x then
        playerText:SetFormattedText("%s: %d,%d", playerLabel, x, y)
    else
        playerText:SetFormattedText("%s: ", playerLabel)
    end
    -- Cursor position relative to the visible map area, like 1.x.
    local container = WorldMapFrame.ScrollContainer
    local centerX, centerY = container:GetCenter()
    if centerX then
        local scale = container:GetEffectiveScale()
        local width, height = container:GetWidth(), container:GetHeight()
        local cursorX, cursorY = GetCursorPosition()
        local mx = (cursorX / scale - (centerX - width / 2)) / width
        local my = (centerY + height / 2 - cursorY / scale) / height
        if mx >= 0 and my >= 0 and mx <= 1 and my <= 1 then
            mouseText:SetFormattedText("Mouse: %d,%d", floor(100 * mx), floor(100 * my))
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
        if not map.ScrollContainer then
            return
        end
        local anchor, border = map.ScrollContainer, map.BorderFrame or map
        holder = CreateFrame("Frame", nil, map)
        holder:SetAllPoints(anchor)
        holder:SetFrameStrata(border:GetFrameStrata())
        holder:SetFrameLevel(border:GetFrameLevel() + 2)
        playerText = holder:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        playerText:SetPoint("BOTTOM", anchor, "BOTTOM", 5, 20)
        playerText:SetJustifyH("LEFT")
        mouseText = holder:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        mouseText:SetJustifyH("LEFT")
        mouseText:SetPoint("BOTTOMLEFT", playerText, "TOPLEFT", 0, 5)
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
        minimapText:SetFormattedText("%d,%d", x, y)
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
