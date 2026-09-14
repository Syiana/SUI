--[[
    SUI 2.0 - Features/CastBars/Defaults.lua

    Settings of the Castbars tab (SUI 1.x keys) and the lookup of the Blizzard
    cast bars shared by this folder. Bar names differ per client, so they are
    resolved at runtime.
]]

local _, ns = ...
local SUI = ns.SUI

SUI:RegisterDefaults("castbars", {
    style = "Custom",       -- "Default" | "Custom"
    timer = true,           -- cast time text
    icon = true,            -- spell icons
    targetCastbar = true,
    focusCastbar = true,
    focusSize = 1,
    targetSize = 1,
    targetOnTop = false,
    focusOnTop = false,
    texture = "Disabled",   -- statusbar texture path, "Disabled" = Blizzard (new in 2.0)
})

local CB = {}
ns.CastBars = CB

-- Player bars: the retail overlay bar (spec switching) shares the look.
function CB.PlayerBars()
    local list = {}
    local player = PlayerCastingBarFrame or CastingBarFrame
    if player then
        list[#list + 1] = player
    end
    if OverlayPlayerCastingBarFrame then
        list[#list + 1] = OverlayPlayerCastingBarFrame
    end
    return list
end

-- Every bar SUI touches: player bars, then target and focus.
function CB.AllBars()
    local list = CB.PlayerBars()
    if TargetFrameSpellBar then
        list[#list + 1] = TargetFrameSpellBar
    end
    if FocusFrameSpellBar then
        list[#list + 1] = FocusFrameSpellBar
    end
    return list
end
