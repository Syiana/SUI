--[[ SUI 2.0 - Features/UnitFrames/Defaults.lua
    Settings of the Unitframes tab. Keys follow SUI 1.x; unitframes.personalbar
    belongs to the NamePlates folder. The 1.x player buff text settings that
    lived under unitframes.buffs / unitframes.debuffs move to the buffs
    category (see Features/Buffs/Defaults.lua).
]]

local _, ns = ...
local SUI = ns.SUI

SUI:RegisterDefaults("unitframes", {
    style = "Default",       -- "Default" | "Classic" (retail only)
    classcolor = true,
    factioncolor = true,     -- show the reputation (name background) bar
    elitecolor = false,      -- keep the golden elite/rare dragon untinted
    pvpbadge = false,        -- show PvP badges
    combaticon = false,
    hitindicator = false,    -- show floating combat text on the portrait
    totemicons = true,
    classbar = true,
    cornericon = true,
    portrait = "Default",    -- "Default" | "ClassIcon"
    hidename = false,
    hidelevel = false,
    hideresting = true,
    overshields = false,
    player = { size = 1 },
    target = { size = 1 },
    focus = { size = 1 },
    -- Target and focus auras
    buffs = {
        mode = "purgeable",  -- all | normal | purgeable | hide
        size = 18,
        perrow = 7,
        targetx = 0,
        targety = 0,
        targettextsize = 10,
    },
    debuffs = {
        mode = "all",        -- all | own | hide
        size = 18,
        perrow = 7,
        targetx = 0,
        targety = 0,
        targettextsize = 10,
    },
})

-- 1.x stored one-shot layout flags next to the settings.
SUI:RegisterMigration("unitframes-1x-flags", function(profile)
    local uf = rawget(profile, "unitframes")
    if type(uf) ~= "table" then
        return
    end
    uf.targetaurarowsmigrated = nil
    uf.targetaurarowslayoutv2 = nil
    uf.targetauralayoutv3 = nil
    uf.targetauralayoutv4 = nil
end)
