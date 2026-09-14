--[[
    SUI 2.0 - Features/Misc/Options.lua

    The Misc tab. Labels follow SUI 1.x; options for features a client does
    not have are limited with `clients` or hidden when the game lacks the API.
]]

local _, ns = ...
local SUI = ns.SUI

local ARENA = { Mainline = true, Mists = true }

SUI.Config:RegisterLayout("Misc", {
    order = 100,
    category = "misc",
    rows = function()
        return {
            { header = { type = "header", label = "Misc" } },
            {
                cvars = {
                    type = "button",
                    text = "CVars Browser",
                    onClick = function()
                        ns.MiscCVarBrowser:Toggle()
                    end,
                    column = 4,
                    order = 1,
                },
            },
            { header = { type = "header", label = "General" } },
            {
                interrupt = { key = "interrupt", type = "checkbox", label = "Interrupt Announce",
                    tooltip = "Announce successful interrupts in party, raid or instance chat", column = 4, order = 1 },
                menubutton = { key = "menubutton", type = "checkbox", label = "Menu Button",
                    tooltip = "Show SUI Button on ESC-Menu", column = 4, order = 2 },
                pulltimer = { key = "pulltimer", type = "checkbox", label = "Pull Timer",
                    tooltip = "Start a pull countdown with /pull [seconds], /pull 0 cancels it (not with DBM or BigWigs)",
                    hidden = function()
                        return not (C_PartyInfo and C_PartyInfo.DoCountdown)
                    end,
                    column = 4, order = 3 },
            },
            {
                fastloot = { key = "fastloot", type = "checkbox", label = "Fast Loot",
                    tooltip = "Loot everything instantly when auto loot is active", column = 4, order = 1 },
                playerlinks = { key = "playerlinks", type = "checkbox", label = "Player Links",
                    tooltip = "Add Raider.io, WarcraftLogs and Check-PvP links to player right-click menus", column = 4, order = 2 },
                lfgdeclined = { key = "lfgdeclined", type = "checkbox", label = "LFG Declined",
                    tooltip = "Show group listings that declined you as available again",
                    clients = { Mainline = true }, column = 4, order = 3 },
            },
            { header = { type = "header", label = "PvP" } },
            {
                safequeue = { key = "safequeue", type = "checkbox", label = "Safe Queue",
                    tooltip = "Show time left to join and remove leave-button on queuepop-window", column = 3, order = 1 },
                tabbinder = { key = "tabbinder", type = "checkbox", label = "Tab Binder",
                    tooltip = "Only target players with TAB in PVP-Combat", column = 3, order = 2 },
                dampening = { key = "dampening", type = "checkbox", label = "Dampening",
                    tooltip = "Shows dampening right below the arena timer", clients = ARENA, column = 3, order = 3 },
                surrender = { key = "surrender", type = "checkbox", label = "Surrender",
                    tooltip = "Allows you to surrender by typing /gg", clients = ARENA, column = 3, order = 4 },
            },
            {
                losecontrol = { key = "losecontrol", type = "checkbox", label = "Lose Control",
                    tooltip = "More transparent Loss of Control Alert frame",
                    hidden = function()
                        return LossOfControlFrame == nil
                    end,
                    column = 3, order = 1 },
                arenanameplate = { key = "arenanameplate", type = "checkbox", label = "Arena Nameplate",
                    tooltip = "Shows Arena number instead of name over nameplate",
                    clients = { Mainline = true, Mists = true, TBC = true }, column = 3, order = 2 },
                achievements = { key = "achievements", type = "checkbox", label = "Track Achievements",
                    tooltip = "Buttons in the conquest frame to track the season's Gladiator, Legend and Strategist achievements",
                    clients = ARENA, column = 3, order = 3 },
            },
            { header = { type = "header", label = "Hide Frames", clients = { Mainline = true } } },
            {
                dragonflying = { key = "dragonflying", type = "checkbox", label = "Dragonflying Wings",
                    tooltip = "Hide the Dragonflying Bar Wings", clients = { Mainline = true }, column = 4, order = 1 },
            },
        }
    end,
})
