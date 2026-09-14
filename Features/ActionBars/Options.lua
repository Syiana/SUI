--[[
    SUI 2.0 - Features/ActionBars/Options.lua

    The Actionbars tab. Bars that do not exist on the running client (e.g.
    bars 6-8) are left out of the mouseover list; the proc glow options only
    show while the Custom glow is selected.
]]

local _, ns = ...
local SUI = ns.SUI
local AB = ns.ActionBars

local MENU_OPTIONS = {
    { value = "show", text = "Show" },
    { value = "mouse_over", text = "Show on Mouseover" },
    { value = "hide", text = "Hide" },
}

local GLOW_MODES = {
    { value = "Blizzard", text = "Blizzard" },
    { value = "Custom", text = "Custom" },
    { value = "Hide", text = "Hide" },
}

local GLOW_STYLES = {
    { value = "Pixel", text = "Pixel" },
    { value = "Autocast", text = "Autocast" },
    { value = "Button", text = "Button" },
}

local BAR_LABELS = {
    bar1 = "Bar 1", bar2 = "Bar 2", bar3 = "Bar 3", bar4 = "Bar 4", bar5 = "Bar 5",
    bar6 = "Bar 6", bar7 = "Bar 7", bar8 = "Bar 8", petbar = "Pet Bar", stancebar = "Stance Bar",
}

local function check(key, label, tooltip, order, extra)
    local el = { key = key, type = "checkbox", label = label, tooltip = tooltip, column = 4, order = order }
    for k, v in pairs(extra or {}) do
        el[k] = v
    end
    return el
end

local function customGlow()
    return SUI:Get("actionbar.buttons.procglow") ~= "Custom"
end

-- Appends the mouseover checkboxes of the bars that exist, four per row.
local function barRows(rows)
    local row, count
    for i = 1, #AB.bars do
        local key = AB.bars[i].key
        if AB.Exists(key) then
            if not row or count == 4 then
                row, count = {}, 0
                rows[#rows + 1] = row
            end
            count = count + 1
            row[key] = {
                key = "bars." .. key, type = "checkbox", label = BAR_LABELS[key], column = 3, order = count,
                tooltip = "Fade " .. BAR_LABELS[key]:lower() .. " out until the mouse is over it.",
            }
        end
    end
end

SUI.Config:RegisterLayout("Actionbar", {
    title = "Actionbars",
    group = "interface",
    order = 20,
    category = "actionbar",
    rows = function()
        local rows = {
            { header = { type = "header", label = "Buttons" } },
            {
                hotkeys = check("buttons.key", "Hotkey Text", "Show the key binding on action buttons.", 1),
                macros = check("buttons.macro", "Macro Text", "Show macro names on action buttons.", 2),
                size = { key = "buttons.size", type = "slider", label = "Text Size", min = 6, max = 20, step = 1, column = 4, order = 3,
                         tooltip = "Font size of the hotkey, macro and count texts." },
            },
            { header = { type = "header", label = "Feedback" } },
            {
                range = check("buttons.range", "Range Color", "Tint icons red when out of range, blue without mana and grey when unusable.", 1),
                desaturate = check("buttons.desaturate", "Desaturate on Cooldown", "Grey out icons while their spell is on cooldown.", 2),
                flash = check("buttons.flash", "Press Flash", "Flash the button when you press its key binding.", 3),
            },
            { header = { type = "header", label = "Proc Glow" } },
            {
                procglow = { key = "buttons.procglow", type = "dropdown", label = "Proc Glow", options = GLOW_MODES, column = 4, order = 1, rebuild = true,
                             tooltip = "Blizzard keeps the default spell alert, Custom replaces it with an SUI glow, Hide shows no proc highlight." },
                procglowstyle = { key = "buttons.procglowstyle", type = "dropdown", label = "Glow Style", options = GLOW_STYLES, column = 4, order = 2,
                                  tooltip = "Animation of the Custom proc glow.", hidden = customGlow },
            },
            {
                procglowtheme = check("buttons.procglowtheme", "Theme Glow Color", "Color the Custom glow with the theme color (class color with the Blizzard and Dark themes).", 1,
                                      { rebuild = true, hidden = customGlow }),
                procglowcolor = { key = "buttons.procglowcolor", type = "color", label = "Glow Color", column = 4, order = 2,
                                  tooltip = "Color of the Custom proc glow.",
                                  hidden = function()
                                      return customGlow() or SUI:Get("actionbar.buttons.procglowtheme")
                                  end },
            },
            { header = { type = "header", label = "Menus" } },
            {
                micromenu = { key = "menu.micromenu", type = "dropdown", label = "Micro Menu", options = MENU_OPTIONS, column = 4, order = 1,
                              tooltip = "Show, fade in on mouseover or hide the micro menu." },
                bagbar = { key = "menu.bagbar", type = "dropdown", label = "Bag Buttons", options = MENU_OPTIONS, column = 4, order = 2,
                           tooltip = "Show, fade in on mouseover or hide the bag buttons." },
            },
            { header = { type = "header", label = "Show on Mouseover" } },
        }
        barRows(rows)
        rows[#rows + 1] = { header = { type = "header", label = "Hide Art" } }
        rows[#rows + 1] = {
            gryphons = check("gryphons", "Hide Gryphons", "Hide the gryphons or end caps next to the main action bar.", 1),
            statusbar = check("statusbar", "Hide XP/Rep/Honor Bar", "Hide the experience, reputation and honor bars.", 2),
        }
        return rows
    end,
})
