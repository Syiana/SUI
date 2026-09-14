--[[
    SUI 2.0 - Media/Media.lua

    Registers SUI's fonts, statusbars and sounds with LibSharedMedia and
    offers them to option dropdowns. Lists are built when asked for, so media
    registered later by other add-ons shows up too.
]]

local _, ns = ...
local SUI = ns.SUI

local LSM = LibStub("LibSharedMedia-3.0")
local path = SUI.mediaPath

local Media = {
    blank = [[Interface\Buttons\WHITE8X8]],
    logo = path .. [[Textures\Config\Logo]],
    icon = path .. [[Icons\SUI]],
    fonts = path .. [[Fonts\]],
    textures = path .. [[Textures\]],
    font = path .. [[Fonts\Prototype.ttf]],
    statusbar = path .. [[Textures\Status\Smooth.blp]],
}
SUI.Media = Media

local western = LSM.LOCALE_BIT_western or 0
local ruRU = LSM.LOCALE_BIT_ruRU or 0

LSM:Register("font", "Default", STANDARD_TEXT_FONT, bit.bor(western, ruRU))
LSM:Register("font", "SUI", path .. [[Fonts\Prototype.ttf]])
LSM:Register("font", "Arial Bold", path .. [[Fonts\Arial_Bold.ttf]])
LSM:Register("font", "Doris P Bold", path .. [[Fonts\DorisPBold.TTF]])
LSM:Register("font", "Exo 2 Bold", path .. [[Fonts\Exo2Bold.ttf]])
LSM:Register("font", "Expressway", path .. [[Fonts\Expressway.ttf]])
LSM:Register("font", "Gotham Narrow Black", path .. [[Fonts\GothamNarrow-Black.ttf]])
LSM:Register("font", "Inter Bold", path .. [[Fonts\InterBold.ttf]])
LSM:Register("font", "MagistralTT Bold", path .. [[Fonts\MagistralTTBold.ttf]])
LSM:Register("font", "Myriad Web Bold", path .. [[Fonts\MyriadWebBold.ttf]])

LSM:Register("statusbar", "Flat", path .. [[Textures\Status\Flat.blp]])
LSM:Register("statusbar", "Melli", path .. [[Textures\Status\Melli.tga]])
LSM:Register("statusbar", "Melli 6px", path .. [[Textures\Status\Melli6px.tga]])
LSM:Register("statusbar", "Melli Dark", path .. [[Textures\Status\MelliDark.tga]])
LSM:Register("statusbar", "Melli Dark Rough", path .. [[Textures\Status\MelliDarkRough.tga]])
LSM:Register("statusbar", "Minimalist", path .. [[Textures\Status\Minimalist.tga]])
LSM:Register("statusbar", "Smooth", path .. [[Textures\Status\Smooth.blp]])
LSM:Register("statusbar", "Smooth v2", path .. [[Textures\Status\Smoothv2.tga]])
LSM:Register("statusbar", "Dragonflight", path .. [[Textures\Status\DragonflightTexture.tga]])

LSM:Register("sound", "SUI Whisper", path .. [[Sounds\whisper.ogg]])

-- Dropdown options { value = path, text = name } sorted by name.
function Media:Options(kind)
    local out = {}
    local names = LSM:List(kind)
    local hash = LSM:HashTable(kind)
    for i = 1, #names do
        local name = names[i]
        out[#out + 1] = { value = hash[name], text = name }
    end
    return out
end

function Media:Fetch(kind, name)
    return LSM:Fetch(kind, name, true)
end
