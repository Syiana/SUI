--[[
    SUI 2.0 - Features/General/Fonts.lua

    Applies general.font to the game's shared font objects, so every font
    string inheriting them follows live. The original font of each object is
    remembered on first change and restored when the Blizzard font is picked
    again. Missing objects are skipped, so one list serves every client.
]]

local _, ns = ...
local SUI = ns.SUI

local _G = _G

-- STANDARD_TEXT_FONT is what the "Default" media entry points at.
local BLIZZARD_FONT = STANDARD_TEXT_FONT

local F = SUI:NewFeature("General.Fonts", {
    category = "general",
    toggle = function(db)
        return db.font ~= nil and db.font ~= BLIZZARD_FONT
    end,
})

local OBJECTS = {
    "SystemFont_NamePlateCastBar", "SystemFont_NamePlateFixed", "SystemFont_LargeNamePlateFixed",
    "SystemFont_LargeNamePlate", "SystemFont_NamePlate", "SystemFont_World", "SystemFont_World_ThickOutline",
    "SystemFont_Outline_Small", "SystemFont_Outline", "SystemFont_InverseShadow_Small", "SystemFont_Med2",
    "SystemFont_Med3", "SystemFont_Shadow_Med3", "SystemFont_Huge1", "SystemFont_Huge1_Outline",
    "SystemFont_OutlineThick_Huge2", "SystemFont_OutlineThick_Huge4", "SystemFont_OutlineThick_WTF",
    "NumberFont_GameNormal", "NumberFont_Shadow_Small", "NumberFont_OutlineThick_Mono_Small", "NumberFont_Shadow_Med",
    "NumberFont_Normal_Med", "NumberFont_Outline_Med", "NumberFont_Outline_Large", "NumberFont_Outline_Huge",
    "Fancy22Font", "QuestFont_Huge", "QuestFont_Outline_Huge", "QuestFont_Super_Huge", "QuestFont_Super_Huge_Outline",
    "SplashHeaderFont", "Game11Font", "Game12Font", "Game13Font", "Game13FontShadow", "Game15Font", "Game18Font",
    "Game20Font", "Game24Font", "Game27Font", "Game30Font", "Game32Font", "Game36Font", "Game48Font",
    "Game48FontShadow", "Game60Font", "Game72Font", "Game11Font_o1", "Game12Font_o1", "Game13Font_o1",
    "Game15Font_o1", "QuestFont_Enormous", "DestinyFontLarge", "CoreAbilityFont", "DestinyFontHuge",
    "QuestFont_Shadow_Small", "MailFont_Large", "SpellFont_Small", "InvoiceFont_Med", "InvoiceFont_Small",
    "Tooltip_Med", "Tooltip_Small", "AchievementFont_Small", "ReputationDetailFont", "FriendsFont_Normal",
    "FriendsFont_Small", "FriendsFont_Large", "FriendsFont_UserText", "GameFont_Gigantic", "GameFontNormalMed3",
    "ChatBubbleFont", "Fancy16Font", "Fancy18Font", "Fancy20Font", "Fancy24Font", "Fancy27Font", "Fancy30Font",
    "Fancy32Font", "Fancy48Font", "SystemFont_Tiny2", "SystemFont_Tiny", "SystemFont_Shadow_Small",
    "SystemFont_Small", "SystemFont_Small2", "SystemFont_Shadow_Small2", "SystemFont_Shadow_Med1_Outline",
    "SystemFont_Shadow_Med1", "QuestFont_Large", "SystemFont_Large", "SystemFont_Shadow_Large_Outline",
    "SystemFont_Shadow_Med2", "SystemFont_Shadow_Large", "SystemFont_Shadow_Large2", "SystemFont_Shadow_Huge1",
    "SystemFont_Huge2", "SystemFont_Shadow_Huge2", "SystemFont_Shadow_Huge3", "SystemFont_Shadow_Outline_Huge3",
    "SystemFont_Shadow_Outline_Huge2", "SystemFont_Med1", "SystemFont_WTF2", "SystemFont_Outline_WTF2",
    "GameTooltipHeader", "System_IME", "Number12Font_o1", "ObjectiveTrackerLineFont", "ObjectiveTrackerHeaderFont",
    "Game15Font_Shadow",
}

-- Fixed size/flags from 1.x (nameplate names and floating combat text).
local FORCED = {
    SystemFont_NamePlateCastBar = { 9 },
    SystemFont_NamePlateFixed = { 8, "OUTLINE" },
    SystemFont_LargeNamePlateFixed = { 8, "OUTLINE" },
    SystemFont_LargeNamePlate = { 8, "OUTLINE" },
    SystemFont_NamePlate = { 8, "OUTLINE" },
    SystemFont_World = { 64 },
    SystemFont_World_ThickOutline = { 64 },
}

local original = {} -- font object -> { path, size, flags }

function F:OnEnable()
    self:Apply()
end

function F:OnRefresh(key)
    if key == "font" then
        self:Apply()
    end
end

function F:Apply()
    local font = self.db.font
    for i = 1, #OBJECTS do
        local name = OBJECTS[i]
        local object = _G[name]
        if object and object.SetFont then
            local saved = original[object]
            if not saved then
                local path, size, flags = object:GetFont()
                saved = { path, size, flags }
                original[object] = saved
            end
            local forced = FORCED[name]
            object:SetFont(font, forced and forced[1] or saved[2], forced and forced[2] or saved[3])
        end
    end
end

function F:OnDisable()
    for object, saved in next, original do
        if saved[1] then
            object:SetFont(saved[1], saved[2], saved[3])
        end
    end
end
