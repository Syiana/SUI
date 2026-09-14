--[[
    SUI 2.0 - Features/Skins/Options.lua

    The Skins tab. Add-on skins are only listed while that add-on is loaded.
    Turning a skin off asks for a reload (the features declare reload).
]]

local _, ns = ...
local SUI = ns.SUI

local IsAddOnLoaded = SUI.Compat.IsAddOnLoaded

local function missing(addon)
    return function()
        return not IsAddOnLoaded(addon)
    end
end

SUI.Config:RegisterLayout("Skins", {
    order = 110,
    category = "skins",
    rows = function()
        return {
            { header = { type = "header", label = "Blizzard" } },
            {
                blizzard = {
                    key = "blizzard", type = "checkbox", label = "Blizzard Frames", column = 6, order = 1,
                    tooltip = "Tint Blizzard windows, dialogs and the game menu with the theme color",
                },
            },
            { addons = { type = "header", label = "AddOns" } },
            {
                details = {
                    key = "details", type = "checkbox", label = "Details!", column = 4, order = 1,
                    tooltip = "Add the SUI skin to Details! (select it in the Details! skin options)",
                    hidden = missing("Details"),
                },
                bartender = {
                    key = "bartender", type = "checkbox", label = "Bartender4", column = 4, order = 2,
                    tooltip = "Tint Bartender4 art and status bars with the theme color",
                    hidden = missing("Bartender4"),
                },
                classicui = {
                    key = "classicui", type = "checkbox", label = "ClassicUI", column = 4, order = 3,
                    tooltip = "Tint ClassicUI action bar art with the theme color",
                    hidden = missing("ClassicUI"),
                },
            },
        }
    end,
})
