--[[
    SUI 2.0 - Features/ActionBars/Text.lua

    Hotkey, macro and count text on action buttons: font size and whether
    hotkey and macro names are shown. Texts are hidden through alpha, which
    Blizzard never resets, so one pass per setting change is enough.
]]

local _, ns = ...
local SUI = ns.SUI
local AB = ns.ActionBars

local F = SUI:NewFeature("ActionBars.Text", {
    category = "actionbar",
})

function F:OnLoad()
    self.buttons = AB.AllButtons()
    local addon = AB.AddonButtons()
    for i = 1, #addon do
        self.buttons[#self.buttons + 1] = addon[i]
    end
end

function F:Apply()
    local db = self.db.buttons
    local font, size = STANDARD_TEXT_FONT, db.size
    local keyAlpha, macroAlpha = db.key and 1 or 0, db.macro and 1 or 0
    for i = 1, #self.buttons do
        local button = self.buttons[i]
        local hotkey = AB.Region(button, "HotKey", "HotKey")
        local macro = AB.Region(button, "Name", "Name")
        local count = AB.Region(button, "Count", "Count")
        if hotkey then
            hotkey:SetFont(font, size, "OUTLINE")
            hotkey:SetAlpha(keyAlpha)
        end
        if macro then
            macro:SetFont(font, size, "OUTLINE")
            macro:SetAlpha(macroAlpha)
        end
        if count then
            count:SetFont(font, size, "OUTLINE")
        end
    end
end

function F:OnEnable()
    self:Apply()
end

function F:OnRefresh(key)
    if key == nil or key == "buttons.key" or key == "buttons.macro" or key == "buttons.size" then
        self:Apply()
    end
end
