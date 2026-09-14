--[[
    SUI 2.0 - Features/General/Options.lua

    Two tabs on the general category: General (appearance, information texts,
    interface tweaks) and Automation (merchant, quests, group and death
    helpers). Automation hides its reset button, the General tab resets the
    whole category.
]]

local _, ns = ...
local SUI = ns.SUI

local function check(key, label, tooltip, order, clients)
    return { key = key, type = "checkbox", label = label, tooltip = tooltip, column = 4, order = order, clients = clients }
end

local function header(label)
    return { header = { type = "header", label = label } }
end

SUI.Config:RegisterLayout("General", {
    group = "interface",
    order = 10,
    category = "general",
    rows = function()
        return {
            header("Appearance"),
            {
                theme = {
                    key = "theme", type = "dropdown", label = "Theme", column = 4, order = 1, rebuild = true,
                    tooltip = "Color of SUI's frame art: Blizzard keeps the default look, Class uses your class color.",
                    options = {
                        { value = "Blizzard", text = "Blizzard" },
                        { value = "Dark", text = "Dark" },
                        { value = "Class", text = "Class" },
                        { value = "Custom", text = "Custom" },
                    },
                },
                color = {
                    key = "color", type = "color", label = "Custom Color", column = 4, order = 2,
                    tooltip = "Color used by the Custom theme.",
                    hidden = function()
                        return SUI:Get("general.theme") ~= "Custom"
                    end,
                },
                font = {
                    key = "font", type = "dropdown", label = "Font", column = 4, order = 3,
                    tooltip = "Font of the game's interface texts.",
                    options = SUI.Media:Options("font"),
                },
            },
            header("Information"),
            {
                ilvl = check("display.ilvl", "Item Level", "Show item level, enchants, gems and durability on the character and inspect frames and item levels in bags.", 1),
                fps = check("display.fps", "FPS", "Show your frame rate in the stats text.", 2),
                ms = check("display.ms", "Latency", "Show your latency in the stats text.", 3),
            },
            {
                speed = check("display.movementSpeed", "Movement Speed", "Show your movement speed in the stats text.", 1),
            },
            header("Interface"),
            {
                afkscreen = check("cosmetic.afkscreen", "AFK Screen", "Fade out the interface and show your character while you are AFK.", 1),
                errors = check("cosmetic.errors", "Show Error Messages", "Show red error messages such as \"Out of range\"; unchecked filters them.", 2),
                cursor = check("cosmetic.cursor", "Cursor Glow", "Show a glow ring around the mouse cursor.", 3),
            },
            {
                talkhead = check("cosmetic.talkhead", "Show Talking Head", "Show Blizzard's talking head frame; unchecked hides it.", 1, { Mainline = true }),
            },
        }
    end,
})

SUI.Config:RegisterLayout("Automation", {
    group = "interface",
    order = 15,
    category = "general",
    reset = false, -- the General tab resets the shared general category
    rows = function()
        return {
            header("Merchant"),
            {
                sell = check("automation.sell", "Sell Junk", "Sell grey items when you open a merchant.", 1),
                stackbuy = check("automation.stackbuy", "Stack Buy", "Alt-click a merchant item to buy a full stack.", 2),
                delete = check("automation.delete", "Auto Fill \"DELETE\"", "Type DELETE into the confirmation when you destroy a valuable item.", 3),
            },
            {
                repair = {
                    key = "automation.repair", type = "dropdown", label = "Repair", column = 4, order = 1,
                    tooltip = "Repair your gear when you open a merchant; Guild Bank falls back to your own gold.",
                    options = {
                        { value = "Disabled", text = "Disabled" },
                        { value = "Player", text = "Own Gold" },
                        { value = "Guild", text = "Guild Bank" },
                    },
                },
            },
            header("Quests & NPCs"),
            {
                quests = check("automation.quests", "Auto Quests", "Accept and turn in quests automatically; hold a modifier key to skip.", 1),
                gossip = check("automation.gossip", "Auto Gossip", "Pick the only gossip option of an NPC automatically; hold a modifier key to skip.", 2),
                cinematic = check("automation.cinematic", "Skip Cinematics", "Skip cinematics and movies automatically; hold Ctrl to watch them.", 3),
            },
            header("Group"),
            {
                invite = check("automation.invite", "Accept Invites", "Accept group invites from friends and guild members.", 1),
                rolecheck = check("automation.rolecheck", "Accept Role Check", "Accept dungeon finder role checks automatically.", 2, { Mainline = true, Mists = true }),
                duel = check("automation.decline", "Decline Duels", "Decline duel and pet battle duel requests automatically.", 3),
            },
            header("Death"),
            {
                release = check("automation.release", "Auto Release", "Release your spirit automatically when you die.", 1),
                resurrect = check("automation.resurrect", "Accept Resurrection", "Accept resurrections automatically unless the caster is still in combat.", 2),
            },
        }
    end,
})
