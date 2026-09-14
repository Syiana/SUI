--[[ SUI 2.0 - Features/Buffs/Defaults.lua
    Player buff and debuff frame settings. size/padding/icons are the 1.x
    keys; the text settings lived under unitframes.buffs / unitframes.debuffs
    in 1.x and are moved here by the buffs-1x-text migration.
]]

local _, ns = ...
local SUI = ns.SUI

SUI:RegisterDefaults("buffs", {
    style = true,   -- SUI borders and texts
    layout = false, -- override Edit Mode icon size, padding and icons per row
    buff = {
        size = 32,
        padding = 2,
        icons = 10,
        collapse = false,
        durationtext = true,
        textsize = 12,
        durationoffset = 5,
        countx = -1,
        county = -2,
    },
    debuff = {
        size = 34,
        padding = 2,
        icons = 10,
        durationtext = true,
        textsize = 12,
        durationoffset = 5,
        countx = -1,
        county = -2,
    },
})

local TEXT_KEYS = { "collapse", "durationtext", "textsize", "durationoffset", "countx", "county" }

SUI:RegisterMigration("buffs-1x-text", function(profile)
    local uf = rawget(profile, "unitframes")
    if type(uf) ~= "table" then
        return
    end
    for from, to in next, { buffs = "buff", debuffs = "debuff" } do
        local old = rawget(uf, from)
        if type(old) == "table" then
            local buffs = profile.buffs
            if type(buffs) ~= "table" then
                buffs = {}
                profile.buffs = buffs
            end
            local target = buffs[to]
            if type(target) ~= "table" then
                target = {}
                buffs[to] = target
            end
            for i = 1, #TEXT_KEYS do
                local key = TEXT_KEYS[i]
                local value = rawget(old, key)
                if value ~= nil then
                    target[key] = value
                    old[key] = nil
                end
            end
        end
    end
end)
