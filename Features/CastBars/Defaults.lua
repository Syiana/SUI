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
    bossCastbar = false,    -- boss1-5 cast bars in the Custom look (new in 2.0)
    bossSize = 1,
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

-- Boss cast bars that exist on this client (boss1-5).
CB.boss = {} -- bar -> true, filled by CB.BossBars
function CB.BossBars()
    local list = {}
    for i = 1, 5 do
        local bar = _G["Boss" .. i .. "TargetFrameSpellBar"]
        if bar then
            list[#list + 1] = bar
            CB.boss[bar] = true
        end
    end
    return list
end

-- Every bar SUI touches: player bars, target, focus and boss bars.
function CB.AllBars()
    local list = CB.PlayerBars()
    if TargetFrameSpellBar then
        list[#list + 1] = TargetFrameSpellBar
    end
    if FocusFrameSpellBar then
        list[#list + 1] = FocusFrameSpellBar
    end
    local boss = CB.BossBars()
    for i = 1, #boss do
        list[#list + 1] = boss[i]
    end
    return list
end

-- SUI 1.x tint: plain vertex colour (theme colour darkened by 0.15), no
-- desaturation. With the Blizzard theme the original colour is restored.
function CB.Tint(texture)
    if not texture then
        return
    end
    if SUI.Theme.enabled then
        texture:SetVertexColor(SUI.Theme:Color(0.15))
    else
        texture:SetVertexColor(1, 1, 1)
    end
end

-- Border and background of a cast bar (classic names the border <Name>Border).
function CB.TintBar(bar)
    CB.Tint(bar.Background)
    local name = bar:GetName()
    CB.Tint(bar.Border or (name and _G[name .. "Border"]))
end

-- Boss bars only get the shared look (icon, texture, timer) while enabled.
function CB.Active(bar, db)
    return not CB.boss[bar] or db.bossCastbar == true
end
