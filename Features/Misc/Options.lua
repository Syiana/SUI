--[[
    SUI 2.0 - Features/Misc/Options.lua

    Three tabs on the misc category: PvP and Group (Social & PvP) and Misc
    (System). Only the Misc tab offers the category reset. Options for
    features a client does not have are limited with `clients` or hidden when
    the game lacks the frame or API.
]]

local _, ns = ...
local SUI = ns.SUI

local ARENA = { Mainline = true, Mists = true }
local RETAIL = { Mainline = true }

local function check(key, label, tooltip, order, extra)
    local el = { key = key, type = "checkbox", label = label, tooltip = tooltip, column = 4, order = order }
    for k, v in pairs(extra or {}) do
        el[k] = v
    end
    return el
end

local function header(label, extra)
    local el = { type = "header", label = label }
    for k, v in pairs(extra or {}) do
        el[k] = v
    end
    return { header = el }
end

local function noLossOfControl()
    return LossOfControlFrame == nil
end

SUI.Config:RegisterLayout("PvP", {
    group = "social",
    order = 10,
    category = "misc",
    reset = false, -- the Misc tab resets the shared misc category
    rows = function()
        return {
            header("Queue"),
            {
                safequeue = check("safequeue", "Safe Queue", "Show the time left to join a popped queue and remove the leave button from the queue popup.", 1),
            },
            header("Arena & Battlegrounds"),
            {
                tabbinder = check("tabbinder", "Tab Binder", "Make TAB target only enemy players in arenas, battlegrounds, PvP zones and duels.", 1),
                dampening = check("dampening", "Dampening", "Show the arena dampening below the arena timer.", 2, { clients = ARENA }),
                surrender = check("surrender", "Surrender", "Surrender an arena by typing /gg.", 3, { clients = ARENA }),
            },
            header("Loss of Control", { hidden = noLossOfControl }),
            {
                losecontrol = check("losecontrol", "Transparent Alert", "Center the Loss of Control alert and remove its dark background.", 1, { hidden = noLossOfControl }),
            },
            header("Achievements", { clients = ARENA }),
            {
                achievements = check("achievements", "Rating Achievements", "Add buttons to the conquest frame that track the season's Gladiator, Legend and Strategist achievements.", 1,
                                     { clients = ARENA }),
            },
        }
    end,
})

SUI.Config:RegisterLayout("Group", {
    group = "social",
    order = 20,
    category = "misc",
    reset = false, -- the Misc tab resets the shared misc category
    rows = function()
        return {
            header("Announcements"),
            {
                interrupt = check("interrupt", "Interrupt Announce", "Announce your successful interrupts in party, raid or instance chat.", 1),
                pulltimer = check("pulltimer", "Pull Timer", "Start a pull countdown with /pull [seconds]; /pull 0 cancels it (not with DBM or BigWigs).", 2, {
                    hidden = function()
                        return not (C_PartyInfo and C_PartyInfo.DoCountdown)
                    end,
                }),
            },
            header("Player Links"),
            {
                playerlinks = check("playerlinks", "Player Links", "Add Raider.io, WarcraftLogs and Check-PvP links to player right-click menus.", 1),
                playerlinkslfg = check("playerlinkslfg", "Group Finder Links",
                    "Add the same links to group finder search results and applicants.|n|cffff5555Changing Blizzard's group finder menus can cause taint errors on \"Sign Up\".|r", 2,
                    { clients = RETAIL }),
            },
            header("Group Finder", { clients = RETAIL }),
            {
                lfgdeclined = check("lfgdeclined", "Declined Listings", "List groups that declined you as available again.", 1, { clients = RETAIL }),
            },
        }
    end,
})

SUI.Config:RegisterLayout("Misc", {
    group = "system",
    order = 20,
    category = "misc",
    rows = function()
        return {
            header("Loot"),
            {
                fastloot = check("fastloot", "Fast Loot", "Loot everything instantly while auto loot is active.", 1),
            },
            header("Interface"),
            {
                menubutton = check("menubutton", "Game Menu Button", "Show an SUI button in the Escape game menu.", 1),
                dragonflying = check("dragonflying", "Hide Skyriding Decoration", "Hide the wing decoration of the skyriding vigor bar.", 2, { clients = RETAIL }),
            },
            header("Tools"),
            {
                cvars = {
                    type = "button", text = "CVar Browser", column = 4, order = 1,
                    onClick = function()
                        ns.MiscCVarBrowser:Toggle()
                    end,
                },
            },
        }
    end,
})
