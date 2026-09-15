--[[
    SUI 2.0 - Features/Chat/Defaults.lua

    Defaults for the chat category. Keys follow SUI 1.x; unused 1.x keys
    (settings.color, x_padding, y_padding, fade.click) are not registered.
    The only 1.x migration folds the removed "Custom"/"SUI" styles into
    "Modern" and drops the old styleversion marker.
]]

local _, ns = ...
local SUI = ns.SUI

SUI:RegisterDefaults("chat", {
    style = "Modern",
    top = false,        -- 1.x: Custom style only
    link = true,
    copy = true,
    friendlist = true,
    quickjoin = false,  -- 1.x: Custom style only
    looticons = false,  -- 1.x: Custom style only
    roleicons = false,  -- 1.x: removed in 10.1.5
    whisperalert = false,
    whispersound = SUI.mediaPath .. [[Sounds\whisper.ogg]],
    shortchannels = false,
    settings = {
        tooltips = true,
        smooth = false,     -- 1.x stored it but always jumped
        pixelscroll = false,
        scrollspeed = 3,
        fade = { enabled = true, out_delay = 60 },
        buttons = { up_and_down = false },
        chat = { alpha = 0.4, font = { name = "Default", size = 12, shadow = true, outline = false } },
        dock = { alpha = 0.8, fade = { enabled = true } },
        edit = { alpha = 0.8, position = "top", offset = 32, font = { name = "Default", size = 12, shadow = true, outline = true } },
    },
})

-- These options only did something in 1.x's dropped Custom style (role icons
-- in none), so a 1.x profile never saw them on Modern/Default. AceDB did not
-- store the old "true" defaults; force the stored value to the new default
-- (off).
SUI:RegisterMigration("chat-1x-custom-only-options", function(profile)
    local chat = rawget(profile, "chat")
    if type(chat) == "table" then
        chat.quickjoin, chat.looticons, chat.roleicons, chat.top = false, false, false, false
    end
end)

SUI:RegisterMigration("chat-1x-style", function(profile)
    local chat = rawget(profile, "chat")
    if type(chat) ~= "table" then
        return
    end
    if chat.style ~= nil and chat.style ~= "Default" then
        chat.style = "Modern"
    end
    chat.styleversion = nil
    local settings = rawget(chat, "settings")
    for _, part in ipairs({ "chat", "edit" }) do
        local font = type(settings) == "table" and type(settings[part]) == "table" and settings[part].font
        if type(font) == "table" and font.name == "" then
            -- AceDB fills in "Default" (the Blizzard chat font).
            font.name = nil
        end
    end
end)
