--[[
    SUI 2.0 - Features/Chat/Options.lua

    The Chat tab. Every value is applied live by the chat features. The
    Input Box, Messages, Tabs & Dock and Scrolling sections belong to the
    Modern style and are hidden while the Default style is selected. Only
    switching the Modern style off needs a reload, which the feature requests
    itself.
]]

local _, ns = ...
local SUI = ns.SUI

local TAINT = "|n|cffff5555Can cause taint on Retail 12.x.|r"

local function notModern()
    return SUI:Get("chat.style") ~= "Modern"
end

local function check(key, label, tooltip, order, extra)
    local el = { key = key, type = "checkbox", label = label, tooltip = tooltip, column = 4, order = order }
    for k, v in pairs(extra or {}) do
        el[k] = v
    end
    return el
end

local function slider(key, label, minValue, maxValue, step, order, tooltip, extra)
    local el = { key = key, type = "slider", label = label, min = minValue, max = maxValue, step = step, column = 4, order = order, tooltip = tooltip }
    for k, v in pairs(extra or {}) do
        el[k] = v
    end
    return el
end

local function modern(label)
    return { header = { type = "header", label = label, hidden = notModern } }
end

local MODERN = { hidden = notModern }

SUI.Config:RegisterLayout("Chat", {
    group = "interface",
    order = 60,
    category = "chat",
    rows = function()
        local fonts = SUI.Media:Options("font")
        table.insert(fonts, 1, { value = "Default", text = "Blizzard Chat Font" })
        return {
            { header = { type = "header", label = "Style" } },
            {
                style = { key = "style", type = "dropdown", label = "Style", column = 4, order = 1, rebuild = true,
                          tooltip = "Modern gives the chat flat backdrops, a slim tab dock and its own fonts; switching back to Default needs a reload.",
                          options = { { value = "Default", text = "Default" }, { value = "Modern", text = "Modern" } } },
            },
            { header = { type = "header", label = "Features" } },
            {
                tooltips = check("settings.tooltips", "Mouseover Tooltips", "Show item, spell and other link tooltips while hovering them in chat.", 1),
                link = check("link", "Link Copy", "Make web links in chat clickable to copy them.", 2),
                copy = check("copy", "Copy Button", "Show a button on each chat frame that opens its history for copying.", 3),
            },
            {
                looticons = check("looticons", "Loot Icons", "Show item icons in loot messages.", 1),
                roleicons = check("roleicons", "Role Icons", "Show the group role of the sender in group chat.", 2),
                top = check("top", "Input on Top", "Place the input box above the chat frame.", 3, {
                    hidden = function()
                        return not notModern()
                    end,
                }),
            },
            { header = { type = "header", label = "Friends" } },
            {
                friendlist = check("friendlist", "Class Color Friends", "Color online friends by class and show their character names in the friend list.", 1),
                quickjoin = check("quickjoin", "Quick Join on Mouseover", "Only show the quick join button next to the chat while the mouse is over it.", 2,
                                  { clients = { Mainline = true } }),
            },
            { header = { type = "header", label = "Whispers" } },
            {
                whisperalert = check("whisperalert", "Whisper Sound", "Play a sound when you receive a whisper.", 1, { rebuild = true }),
                whispersound = { key = "whispersound", type = "dropdown", label = "Sound", column = 4, order = 2,
                                 tooltip = "Sound played for incoming whispers.", options = SUI.Media:Options("sound"),
                                 hidden = function()
                                     return not SUI:Get("chat.whisperalert")
                                 end },
            },
            modern("Input Box"),
            {
                editposition = { key = "settings.edit.position", type = "dropdown", label = "Position", column = 4, order = 1, hidden = notModern,
                                 tooltip = "Place the input box above or below the chat frame.",
                                 options = { { value = "top", text = "Top" }, { value = "bottom", text = "Bottom" } } },
                editoffset = slider("settings.edit.offset", "Offset", 0, 64, 1, 2, "Distance between the input box and the chat frame.", MODERN),
                editalpha = slider("settings.edit.alpha", "Background Alpha", 0, 1, 0.1, 3, "Opacity of the input box background.", { precision = 1, hidden = notModern }),
            },
            {
                editfont = { key = "settings.edit.font.name", type = "dropdown", label = "Font", column = 4, order = 1, options = fonts, hidden = notModern,
                             tooltip = "Font of the input box." },
                editfontsize = slider("settings.edit.font.size", "Font Size", 10, 20, 1, 2, "Font size of the input box.", MODERN),
                editfontoutline = check("settings.edit.font.outline", "Font Outline", "Draw an outline around the input box text.", 3, MODERN),
            },
            {
                editfontshadow = check("settings.edit.font.shadow", "Font Shadow", "Draw a shadow behind the input box text.", 1, MODERN),
            },
            modern("Messages"),
            {
                chatalpha = slider("settings.chat.alpha", "Background Alpha", 0, 1, 0.1, 1, "Opacity of the chat frame background.", { precision = 1, hidden = notModern }),
                chatfont = { key = "settings.chat.font.name", type = "dropdown", label = "Font", column = 4, order = 2, options = fonts, hidden = notModern,
                             tooltip = "Font of the chat messages." },
                chatfontsize = slider("settings.chat.font.size", "Font Size", 10, 20, 1, 3, "Font size of the chat messages.", MODERN),
            },
            {
                chatfontoutline = check("settings.chat.font.outline", "Font Outline", "Draw an outline around chat messages.", 1, MODERN),
                chatfontshadow = check("settings.chat.font.shadow", "Font Shadow", "Draw a shadow behind chat messages.", 2, MODERN),
                messagefade = check("settings.fade.enabled", "Message Fading", "Fade out old chat messages.", 3, { rebuild = true, hidden = notModern }),
            },
            {
                fadeoutdelay = slider("settings.fade.out_delay", "Fade Out Delay", 10, 240, 1, 1, "Seconds before a message fades out.", {
                    hidden = function()
                        return notModern() or not SUI:Get("chat.settings.fade.enabled")
                    end,
                }),
            },
            modern("Tabs & Dock"),
            {
                dockfade = check("settings.dock.fade.enabled", "Fade Tabs and Buttons", "Fade chat tabs and buttons out when the mouse leaves the chat.", 1, MODERN),
                dockalpha = slider("settings.dock.alpha", "Dock Background Alpha", 0, 1, 0.1, 2, "Opacity of the tab dock background.", { precision = 1, hidden = notModern }),
            },
            modern("Scrolling"),
            {
                scrollbuttons = check("settings.buttons.up_and_down", "Scroll Buttons", "Show scroll up and down buttons on the chat frames.", 1, MODERN),
                smooth = check("settings.smooth", "Smooth Jump to Bottom", "Ease back to the newest message instead of jumping there.", 2, MODERN),
            },
            { header = { type = "header", label = "Advanced" } },
            {
                shortchannels = check("shortchannels", "Short Channel Names",
                    "Shorten channel and whisper tags ([1. General] -> [1], [Guild] -> [G])." .. TAINT, 1),
                pixelscroll = check("settings.pixelscroll", "Pixel Scrolling",
                    "Scroll chat frames smoothly with the mouse wheel." .. TAINT, 2, { rebuild = true }),
                scrollspeed = slider("settings.scrollspeed", "Scroll Speed", 1, 10, 1, 3, "Lines scrolled per mouse wheel notch with Pixel Scrolling." .. TAINT, {
                    hidden = function()
                        return not SUI:Get("chat.settings.pixelscroll")
                    end,
                }),
            },
        }
    end,
})
