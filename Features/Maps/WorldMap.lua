--[[
    SUI 2.0 - Features/Maps/WorldMap.lua

    World map opacity and the smaller world map, plus the theme tint of the
    world map border (1.x skin). The map can hold protected content, so size
    changes wait until combat ends. Blizzard's "fade map while moving" option
    also drives the map alpha; the opacity is re-applied every time the map
    opens.
]]

local _, ns = ...
local SUI = ns.SUI

local SMALL_SCALE = 0.75

local F = SUI:NewFeature("Maps.WorldMap", {
    category = "maps",
    toggle = function(db)
        return db.small or db.opacity < 1
    end,
})

local applyScale -- built once in OnLoad

local function applyAlpha()
    if F.enabled and WorldMapFrame then
        WorldMapFrame:SetAlpha(F.db.opacity)
    end
end

function F:OnLoad()
    local feature = self
    applyScale = function()
        if WorldMapFrame then
            WorldMapFrame:SetScale(feature.enabled and feature.db.small and SMALL_SCALE or 1)
        end
    end
    SUI:OnAddonLoaded("Blizzard_WorldMap", function()
        WorldMapFrame:HookScript("OnShow", applyAlpha)
        applyAlpha()
    end)
end

function F:OnEnable()
    applyAlpha()
    SUI:RunAfterCombat(applyScale)
end

function F:OnRefresh(key)
    if key == "opacity" then
        applyAlpha()
    elseif key == "small" then
        SUI:RunAfterCombat(applyScale)
    end
end

function F:OnDisable()
    if WorldMapFrame then
        WorldMapFrame:SetAlpha(1)
    end
    SUI:RunAfterCombat(applyScale)
end

SUI.Skin:Register("Blizzard_WorldMap", {
    "WorldMapFrame", "WorldMapFrame.BorderFrame", "WorldMapFrame.BorderFrame.NineSlice",
    "WorldMapFrame.NavBar", "WorldMapFrame.NavBar.overlay",
})
