--[[
    SUI 2.0 - Media/Media.lua

    Registers SUI's fonts, statusbar textures and sounds with LibSharedMedia
    so every dropdown in the options can offer them (and other addons can use
    them too). Also exposes SUI.Media with commonly used texture paths.
]]

local LSM = LibStub("LibSharedMedia-3.0")
local path = SUI.mediaPath

SUI.Media = {
    blank = "Interface\ChatFrame\ChatFrameBackground",
    logo = path .. "Textures\Config\Logo",
    icon = path .. "Icons\SUI",
    gloss = path .. "Textures\Core\gloss",
    glossBorder = path .. "Textures\Core\gloss_border",
    glossBorderWhite = path .. "Textures\Core\gloss_border_w",
    glossGrey = path .. "Textures\Core\gloss_grey",
    outerShadow = path .. "Textures\Core\outer_shadow",
    flash = path .. "Textures\Core\flash",
    hover = path .. "Textures\Core\hover",
    pushed = path .. "Textures\Core\pushed",
    checked = path .. "Textures\Core\checked",
    buttonBackground = path .. "Textures\Core\button_background",
    buttonBackgroundFlat = path .. "Textures\Core\button_background_flat",
    normal = path .. "Textures\Core\Normal",
    normalN = path .. "Textures\Core\Normal_N",
    textureShadow = path .. "Textures\Nameplates\textureShadow",
    focusTexture = path .. "Textures\Nameplates\focusTexture",
    tooltipBorder = path .. "Textures\Tooltip\UI-Tooltip-Border",
    tooltipBar = path .. "Textures\Tooltip\UI-TargetingFrame-BarFill_test",
    whisper = path .. "Sounds\whisper.ogg",
    classPortraits = path .. "Textures\ClassPortraits\\",
    unitframes = path .. "Textures\UnitFrames\\",
    raidframes = path .. "Textures\RaidFrames\\",
    chat = path .. "Textures\Chat\\",
}

-- Fonts
local western = bit.bor(LSM.LOCALE_BIT_western, LSM.LOCALE_BIT_ruRU)
LSM:Register("font", "SUI Prototype", path .. "Fonts\Prototype.ttf", western)
LSM:Register("font", "Arial Bold", path .. "Fonts\Arial_Bold.ttf", western)
LSM:Register("font", "Doris P Bold", path .. "Fonts\DorisPBold.TTF", western)
LSM:Register("font", "Exo 2 Bold", path .. "Fonts\Exo2Bold.ttf", western)
LSM:Register("font", "Expressway", path .. "Fonts\Expressway.ttf", western)
LSM:Register("font", "Gotham Narrow Black", path .. "Fonts\GothamNarrow-Black.ttf", western)
LSM:Register("font", "Inter Bold", path .. "Fonts\InterBold.ttf", western)
LSM:Register("font", "MagistralTT Bold", path .. "Fonts\MagistralTTBold.ttf", western)
LSM:Register("font", "Myriad Web Bold", path .. "Fonts\MyriadWebBold.ttf", western)

-- Statusbar textures
local status = path .. "Textures\Status\\"
LSM:Register("statusbar", "SUI Flat", status .. "Flat.blp")
LSM:Register("statusbar", "SUI Smooth", status .. "Smooth.blp")
LSM:Register("statusbar", "SUI Smooth v2", status .. "Smoothv2.tga")
LSM:Register("statusbar", "SUI Blizzard", status .. "Blizzard.blp")
LSM:Register("statusbar", "Ace", status .. "Ace.tga")
LSM:Register("statusbar", "Aluminum", status .. "Aluminum.tga")
LSM:Register("statusbar", "Banto", status .. "Banto.tga")
LSM:Register("statusbar", "Charcoal", status .. "Charcoal.tga")
LSM:Register("statusbar", "Dragonflight", status .. "DragonflightTexture.tga")
LSM:Register("statusbar", "Glaze", status .. "Glaze.tga")
LSM:Register("statusbar", "LiteStep", status .. "LiteStep.tga")
LSM:Register("statusbar", "Melli", status .. "Melli.tga")
LSM:Register("statusbar", "Melli 6px", status .. "Melli6px.tga")
LSM:Register("statusbar", "Melli Dark", status .. "MelliDark.tga")
LSM:Register("statusbar", "Melli Dark Rough", status .. "MelliDarkRough.tga")
LSM:Register("statusbar", "Minimalist", status .. "Minimalist.tga")
LSM:Register("statusbar", "Otravi", status .. "Otravi.tga")
LSM:Register("statusbar", "Perl", status .. "Perl.tga")
LSM:Register("statusbar", "Striped", status .. "Striped.tga")
LSM:Register("statusbar", "Swag", status .. "Swag.blp")

-- Sounds
LSM:Register("sound", "SUI Whisper", path .. "Sounds\whisper.ogg")

--- Builds an option list ({ value = name, text = name }) for a LSM media type.
function SUI:GetMediaList(mediaType, includeDefault)
    local list = {}
    if includeDefault then
        list[#list + 1] = { value = "Default", text = "Default" }
    end
    for _, name in ipairs(LSM:List(mediaType)) do
        list[#list + 1] = { value = name, text = name }
    end
    return list
end
