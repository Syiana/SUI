--[[
    SUI 2.0 - Features/RaidFrames/Defaults.lua

    Settings of the Raidframes tab. texture, alwaysontop, size, width, height,
    raidscale and partyscale keep their SUI 1.x keys; everything else is new
    in 2.0. Aura keys follow the 1.x auras module; migrations normalise 1.x
    texture paths and convert the 2.0 preview aura keys.
]]

local _, ns = ...
local SUI = ns.SUI

SUI:RegisterDefaults("raidframes", {
    texture = SUI.Media.textures .. [[Status\Flat.blp]], -- path or "Disabled" (Blizzard)
    alwaysontop = false,
    size = false, -- custom party frame size
    width = 100,
    height = 75,
    raidscale = 1,
    partyscale = 1,
    keepenabled = false,
    solo = false,
    mouseover = false,
    colors = "Default",    -- "Default" | "Class" | "Dark"
    roleicons = "Default", -- "Default" | "TankHealer" | "Hide"
    names = {
        mode = "Default",  -- "Default" | "Short" | "Hide"
        length = 8,
        classcolor = false,
        font = "",         -- "" = Blizzard
        size = 10,
    },
    health = {
        hide = false,
        color = "Default", -- "Default" | "Class"
        font = "",
        size = 12,
    },
    -- SUI 1.x aura keys (enabled, tooltips, buffs, debuffs, defensives) plus
    -- 2.0 additions: dispel, point/x/y/grow/spacing/duration/count per row.
    -- Sizes are a share of the frame height in percent (as in 1.x).
    auras = {
        enabled = SUI.IsRetail, -- 1.x default on retail; classic is new and opt-in
        tooltips = true,
        dispel = false,          -- retail: frame-wide dispel highlight
        buffs = {
            mode = "mine",       -- "mine" | "all" | "hide"
            filter = "raid",     -- "raid" | "important" (retail) | "all"
            size = 33, max = 6, perrow = 3,
            point = "BOTTOMRIGHT", x = 0, y = 0, grow = "LEFT",
            spacing = 2, duration = true, count = true,
        },
        debuffs = {
            mode = "all",        -- "all" | "dispellable" | "hide"
            lead = true,         -- boss and role debuffs first, x1.3
            size = 55, max = 3, perrow = 5,
            point = "BOTTOMLEFT", x = 0, y = 0, grow = "RIGHT",
            spacing = 2, duration = true, count = true,
        },
        defensives = {          -- retail
            mode = "big",        -- "big" | "all" | "hide"
            size = 60, point = "CENTER", x = 0, y = 0,
        },
    },
})

-- Retail: which Blizzard raid aura CVars SUI switched off (1.x ledger, kept
-- under its 1.x name so an upgraded character still gets them back).
SUI:RegisterDefaults("raidauracvars", {}, "char")

-- 1.x stored LibSharedMedia paths spelled "Interface\Addons\..." and used
-- "Interface\Default" for Blizzard's texture. Re-running is harmless.
SUI:RegisterMigration("raidframes-1x-texture-path", function(profile)
    local raid = rawget(profile, "raidframes")
    local texture = type(raid) == "table" and rawget(raid, "texture")
    if type(texture) ~= "string" then
        return
    end
    if texture == [[Interface\Default]] then
        raid.texture = "Disabled"
        return
    end
    local prefix = [[interface\addons\sui\media\]]
    if texture:sub(1, #prefix):lower() == prefix then
        raid.texture = SUI.mediaPath .. texture:sub(#prefix + 1)
    end
end)

-- 2.0 previews stored flat aura switches (auras.defensives = boolean,
-- buffs.enabled/filter/anchor/perRow in pixels); 1.x profiles with buffs in
-- the bottom-left corner put debuffs in the other corner. Idempotent.
local PREVIEW_BUFF_FILTER = { All = "all", Mine = "all", Defensives = "all" }

SUI:RegisterMigration("raidframes-auras-structure", function(profile)
    local raid = rawget(profile, "raidframes")
    local auras = type(raid) == "table" and rawget(raid, "auras")
    if type(auras) ~= "table" then
        return
    end
    local defensives = rawget(auras, "defensives")
    if type(defensives) == "boolean" then
        -- AceDB only fills default sub-tables at load, so start from a copy.
        local fresh = CopyTable(SUI:GetDefaults("raidframes").auras.defensives)
        fresh.mode = defensives and "big" or "hide"
        auras.defensives = fresh
    end
    auras.important, auras.size = nil, nil

    for _, side in ipairs({ "buffs", "debuffs" }) do
        local t = rawget(auras, side)
        if type(t) == "table" and rawget(t, "enabled") ~= nil then
            local enabled, filter = t.enabled, rawget(t, "filter")
            if side == "buffs" then
                t.mode = not enabled and "hide" or (filter == "Mine" and "mine" or "all")
                t.filter = filter and PREVIEW_BUFF_FILTER[filter] or nil
            else
                t.mode = not enabled and "hide" or (filter == "Dispellable" and "dispellable" or "all")
                t.filter = nil
            end
            if rawget(t, "anchor") ~= nil then
                t.point = t.anchor
            end
            if rawget(t, "perRow") ~= nil then
                t.perrow = t.perRow
            end
            t.enabled, t.anchor, t.perRow, t.size = nil, nil, nil, nil -- preview sizes were pixels
        end
    end

    local buffs, debuffs = rawget(auras, "buffs"), rawget(auras, "debuffs")
    if type(buffs) == "table" and rawget(buffs, "point") == "BOTTOMLEFT" and rawget(buffs, "grow") == nil then
        buffs.grow = "RIGHT"
        if type(debuffs) ~= "table" then -- raw 1.x import data without debuff settings
            debuffs = {}
            auras.debuffs = debuffs
        end
        if rawget(debuffs, "point") == nil then
            debuffs.point, debuffs.grow = "BOTTOMRIGHT", "LEFT"
        end
    end
end)
