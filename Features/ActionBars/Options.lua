--[[
    SUI 2.0 - Features/ActionBars/Options.lua

    The Actionbar tab. Labels follow SUI 1.x; bars that do not exist on the
    running client (e.g. bars 6-8) are left out.
]]

local _, ns = ...
local SUI = ns.SUI
local AB = ns.ActionBars

local MENU_OPTIONS = {
    { value = "show", text = "Show" },
    { value = "mouse_over", text = "Show on Mouseover" },
    { value = "hide", text = "Hide" },
}

local function barBox(key, label, order)
    return {
        key = "bars." .. key, type = "checkbox", label = label, column = 3, order = order,
        hidden = function()
            return not AB.Exists(key)
        end,
    }
end

SUI.Config:RegisterLayout("Actionbar", {
    order = 40,
    category = "actionbar",
    rows = function()
        return {
            { header = { type = "header", label = "Buttons" } },
            {
                hotkeys = { key = "buttons.key", type = "checkbox", label = "Hotkeys Text", tooltip = "Show Hotkeys text", column = 4, order = 1 },
                macros = { key = "buttons.macro", type = "checkbox", label = "Macro Text", tooltip = "Show Macro text", column = 4, order = 2 },
                flash = { key = "buttons.flash", type = "checkbox", label = "Flash Animation", tooltip = "Flash spell-icon when pressing it", column = 4, order = 3 },
            },
            {
                range = { key = "buttons.range", type = "checkbox", label = "Range Color", tooltip = "Show spell-color in red if out of range", column = 4, order = 1 },
                desaturate = { key = "buttons.desaturate", type = "checkbox", label = "Desaturate on Cooldown", tooltip = "Grey out spell-icons while they are on cooldown", column = 4, order = 2 },
                size = { key = "buttons.size", type = "slider", label = "Text size", min = 6, max = 20, step = 1, column = 4, order = 3 },
            },
            {
                bagbar = { key = "menu.bagbar", type = "dropdown", label = "Bag Buttons", options = MENU_OPTIONS, column = 4, order = 1 },
                micromenu = { key = "menu.micromenu", type = "dropdown", label = "MicroMenu", options = MENU_OPTIONS, column = 4, order = 2 },
            },
            { header = { type = "header", label = "Hide Frames" } },
            {
                gryphons = { key = "gryphons", type = "checkbox", label = "Gryphons", tooltip = "Hide the gryphons / end caps next to the main action bar", column = 4, order = 1 },
                statusbar = { key = "statusbar", type = "checkbox", label = "XP/Rep/Honor Bar", tooltip = "Hide the XP/Rep/Honor Bar", column = 4, order = 2 },
            },
            { header = { type = "header", label = "Show on Mouseover" } },
            {
                actionbar1 = barBox("bar1", "Bar 1", 1),
                actionbar2 = barBox("bar2", "Bar 2", 2),
                actionbar3 = barBox("bar3", "Bar 3", 3),
                actionbar4 = barBox("bar4", "Bar 4", 4),
            },
            {
                actionbar5 = barBox("bar5", "Bar 5", 1),
                actionbar6 = barBox("bar6", "Bar 6", 2),
                actionbar7 = barBox("bar7", "Bar 7", 3),
                actionbar8 = barBox("bar8", "Bar 8", 4),
            },
            {
                petbar = barBox("petbar", "Pet Bar", 1),
                stancebar = barBox("stancebar", "Stance Bar", 2),
            },
        }
    end,
})
