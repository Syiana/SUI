--[[
    SUI 2.0 - Features/General/Options.lua

    The General tab: appearance (theme, colour, font), automation,
    information texts and interface tweaks. Labels follow SUI 1.x.
]]

local _, ns = ...
local SUI = ns.SUI

local function checkbox(key, label, tooltip, column, order, clients)
    return { key = key, type = "checkbox", label = label, tooltip = tooltip, column = column, order = order, clients = clients }
end

SUI.Config:RegisterLayout("General", {
    order = 10,
    category = "general",
    rows = function()
        return {
            { header = { type = "header", label = "Appearance" } },
            {
                theme = {
                    key = "theme", type = "dropdown", label = "Theme", column = 4, order = 1,
                    options = {
                        { value = "Blizzard", text = "Blizzard" },
                        { value = "Dark", text = "Dark" },
                        { value = "Class", text = "Class" },
                        { value = "Custom", text = "Custom" },
                    },
                },
                font = { key = "font", type = "dropdown", label = "Font", column = 5, order = 2, options = SUI.Media:Options("font") },
                color = { key = "color", type = "color", label = "Custom Color", tooltip = "Used by the Custom theme", column = 3, order = 3 },
            },
            { header = { type = "header", label = "Automation" } },
            {
                sell = checkbox("automation.sell", "Sell", "Sells grey items automatically", 3, 1),
                delete = checkbox("automation.delete", "Delete", 'Inserts "DELETE" when deleting Rare+ items', 3, 2),
                duel = checkbox("automation.decline", "Decline Duel", "Declines duels (and pet battle duels) automatically", 3, 3),
                release = checkbox("automation.release", "Release", "Release automatically when you died", 3, 4),
            },
            {
                resurrect = checkbox("automation.resurrect", "Accept Resurrect", "Accept ress automatically", 3, 1),
                invite = checkbox("automation.invite", "Accept Invite", "Accept group invites from friends and guild members", 3, 2),
                cinematic = checkbox("automation.cinematic", "Skip Cinematics", "Skip cinematics automatically (hold Ctrl to watch)", 3, 3),
                stackbuy = checkbox("automation.stackbuy", "Stack Buy", "Alt-click a merchant item to buy a full stack", 3, 4),
            },
            {
                quests = checkbox("automation.quests", "Quests", "Accept and turn in quests automatically (hold a modifier key to skip)", 3, 1),
                gossip = checkbox("automation.gossip", "Gossip", "Select the only gossip option automatically (hold a modifier key to skip)", 3, 2),
                rolecheck = checkbox("automation.rolecheck", "Role Check", "Accept dungeon finder role checks automatically", 3, 3, { Mainline = true, Mists = true }),
            },
            {
                repair = {
                    key = "automation.repair", type = "dropdown", label = "Repair", column = 9, order = 1,
                    options = {
                        { value = "Disabled", text = "Disabled" },
                        { value = "Player", text = "Repair automatically" },
                        { value = "Guild", text = "Repair automatically using guild bank" },
                    },
                },
            },
            { header = { type = "header", label = "Information" } },
            {
                items = checkbox("display.ilvl", "Item Info", "Display item information on items in bags and character/inspect frame", 4, 1),
                fps = checkbox("display.fps", "FPS", "Show current FPS", 2, 2),
                ms = checkbox("display.ms", "MS", "Show current ping", 2, 3),
                movementSpeed = checkbox("display.movementSpeed", "Speed", "Show current movement speed", 4, 4),
            },
            { header = { type = "header", label = "Interface" } },
            {
                afkscreen = checkbox("cosmetic.afkscreen", "AFK Screen", "Display a nice screen while you are AFK", 3, 1),
                talkhead = checkbox("cosmetic.talkhead", "Talking Head", "Show Talking Head frame", 3, 2, { Mainline = true }),
                errors = checkbox("cosmetic.errors", "Messages", "Display Error Messages (Out of Range etc.)", 3, 3),
                cursor = checkbox("cosmetic.cursor", "Cursor Glow", "Show a glow ring around the mouse cursor", 3, 4),
            },
        }
    end,
})
