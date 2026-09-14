--[[
    SUI 2.0 - Features/RaidFrames/Defaults.lua

    Settings of the Raidframes tab. texture, alwaysontop, size, width, height,
    raidscale and partyscale keep their SUI 1.x keys; everything else is new
    in 2.0. The only migration normalises 1.x texture paths.
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
    auras = {
        dispel = false,
        defensives = false,
        important = false,
        size = 20,
    },
})

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
