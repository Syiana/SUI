--[[
    SUI 2.0 - Features/Chat/Options.lua

    The Chat tab. Labels follow SUI 1.x; every value is applied live by the
    chat features. Only switching the Modern style off needs a reload, which
    the feature requests itself.
]]

local _, ns = ...
local SUI = ns.SUI

local function checkbox(key, label, tooltip, order, extra)
    local row = { key = key, type = "checkbox", label = label, tooltip = tooltip, column = 4, order = order }
    for k, v in pairs(extra or {}) do
        row[k] = v
    end
    return row
end

local function slider(key, label, minValue, maxValue, step, order, precision)
    return { key = key, type = "slider", label = label, min = minValue, max = maxValue, step = step, precision = precision, column = 4, order = order }
end

SUI.Config:RegisterLayout("Chat", {
    order = 90,
    category = "chat",
    rows = function()
        local fonts = SUI.Media:Options("font")
        table.insert(fonts, 1, { value = "Default", text = "Blizzard Chat Font" })
        return {
            { header = { type = "header", label = "Chat" } },
            {
                style = { key = "style", type = "dropdown", label = "Style", column = 4, order = 1,
                          tooltip = "Switching from Modern back to Default requires a reload.",
                          options = { { value = "Default", text = "Default" }, { value = "Modern", text = "Modern" } } },
                tooltips = checkbox("settings.tooltips", "Mouseover Tooltips", "Show hyperlink tooltips on mouseover", 2),
                friendlist = checkbox("friendlist", "Class Friendlist", "Show character names in class color in the friend list", 3),
            },
            {
                quickjoin = checkbox("quickjoin", "Friendlist Icon Mouseover", "Show the friendlist icon only on mouseover", 1,
                                     { clients = { Mainline = true } }),
                link = checkbox("link", "Link Copy", "Make links clickable to copy them", 2),
                copy = checkbox("copy", "Copy Button", "Show the copy chat-history button", 3),
            },
            {
                looticons = checkbox("looticons", "Loot Icons", "Show item icons in loot messages", 1),
                roleicons = checkbox("roleicons", "Role Icons", "Show the group role of the sender in group chat", 2),
                top = checkbox("top", "Input on Top", "Place the input box above the chat (Default style)", 3),
            },
            {
                whisperalert = checkbox("whisperalert", "Whisper Sound", "Play a sound when you receive a whisper", 1),
                whispersound = { key = "whispersound", type = "dropdown", label = "Whisper Sound File", column = 4, order = 2,
                                 options = SUI.Media:Options("sound") },
            },
            { header = { type = "header", label = "Modern Chat" } },
            {
                editposition = { key = "settings.edit.position", type = "dropdown", label = "Input Position", column = 4, order = 1,
                                 options = { { value = "top", text = "Top" }, { value = "bottom", text = "Bottom" } } },
                editoffset = slider("settings.edit.offset", "Input Offset", 0, 64, 1, 2),
                editalpha = slider("settings.edit.alpha", "Input Background Alpha", 0, 1, 0.1, 3, 1),
            },
            {
                editfont = { key = "settings.edit.font.name", type = "dropdown", label = "Input Font", column = 4, order = 1, options = fonts },
                editfontsize = slider("settings.edit.font.size", "Input Font Size", 10, 20, 1, 2),
                editfontoutline = checkbox("settings.edit.font.outline", "Input Font Outline", nil, 3),
            },
            {
                editfontshadow = checkbox("settings.edit.font.shadow", "Input Font Shadow", nil, 1),
                chatalpha = slider("settings.chat.alpha", "Chat Background Alpha", 0, 1, 0.1, 2, 1),
                chatfont = { key = "settings.chat.font.name", type = "dropdown", label = "Chat Font", column = 4, order = 3, options = fonts },
            },
            {
                chatfontsize = slider("settings.chat.font.size", "Chat Font Size", 10, 20, 1, 1),
                chatfontoutline = checkbox("settings.chat.font.outline", "Chat Font Outline", nil, 2),
                chatfontshadow = checkbox("settings.chat.font.shadow", "Chat Font Shadow", nil, 3),
            },
            {
                messagefade = checkbox("settings.fade.enabled", "Message Fading", "Fade out old messages", 1),
                fadeoutdelay = slider("settings.fade.out_delay", "Fade Out Delay", 10, 240, 1, 2),
                dockfade = checkbox("settings.dock.fade.enabled", "Tabs and Buttons Fading", "Fade tabs and buttons when the mouse leaves the chat", 3),
            },
            {
                dockalpha = slider("settings.dock.alpha", "Dock Alpha", 0, 1, 0.1, 1, 1),
                scrollbuttons = checkbox("settings.buttons.up_and_down", "Scroll Buttons", "Show scroll up and down buttons", 2),
                smooth = checkbox("settings.smooth", "Smooth Scrolling", "Ease back to the newest message instead of jumping", 3),
            },
        }
    end,
})
