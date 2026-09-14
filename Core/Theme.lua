--[[
    SUI 2.0 - Core/Theme.lua

    The theme colour is resolved once and kept as three numbers. Painting a
    texture records it, so a theme change repaints everything live instead of
    requiring a reload.

    Themes: Blizzard (no tint), Dark, Class, Custom.
]]

local _, ns = ...
local SUI = ns.SUI

local next, max, UnitClass = next, math.max, UnitClass

local Theme = {
    name = "Dark",
    enabled = true,
    r = 0.3, g = 0.3, b = 0.3,
}
SUI.Theme = Theme

-- texture -> tint offset (weak keys: textures of released frames can go).
-- Theme-tinted and flat-grey textures are kept apart so both keep their value.
local painted = setmetatable({}, { __mode = "k" })
local paintedFlat = setmetatable({}, { __mode = "k" })

SUI:RegisterDefaults("general", {
    theme = "Dark",
    color = { r = 0, g = 0, b = 0, a = 1 },
    font = [[Interface\AddOns\SUI\Media\Fonts\Prototype.ttf]],
    texture = [[Interface\AddOns\SUI\Media\Textures\Status\Smooth.blp]],
})

function Theme:Update()
    local general = SUI.db.profile.general
    local name = general.theme
    self.name = name
    self.enabled = name ~= "Blizzard"
    if name == "Class" then
        local _, class = UnitClass("player")
        self.r, self.g, self.b = SUI.Compat.GetClassColor(class)
    elseif name == "Custom" then
        local c = general.color
        self.r, self.g, self.b = c.r, c.g, c.b
    else
        self.r, self.g, self.b = 0.3, 0.3, 0.3
    end
end

-- Theme colour darkened by `sub` (default 0), as r, g, b.
function Theme:Color(sub)
    sub = sub or 0
    return max(self.r - sub, 0), max(self.g - sub, 0), max(self.b - sub, 0)
end

-- Tints a texture with the theme colour (useTheme) or flat dark grey.
-- A texture painted once is repainted automatically on theme changes.
function Theme:Paint(texture, useTheme, sub)
    if not texture then
        return
    end
    sub = sub or 0.15
    if useTheme then
        painted[texture], paintedFlat[texture] = sub, nil
    else
        paintedFlat[texture], painted[texture] = sub, nil
    end
    if not self.enabled then
        return
    end
    if texture.SetDesaturated then
        texture:SetDesaturated(true)
    end
    if useTheme then
        texture:SetVertexColor(self:Color(sub))
    else
        texture:SetVertexColor(sub, sub, sub)
    end
end

local function repaint(texture, enabled, r, g, b)
    if texture.SetDesaturated then
        texture:SetDesaturated(enabled)
    end
    texture:SetVertexColor(r, g, b)
end

function Theme:Repaint()
    local enabled = self.enabled
    for texture, sub in next, painted do
        if enabled then
            repaint(texture, true, self:Color(sub))
        else
            repaint(texture, false, 1, 1, 1)
        end
    end
    for texture, sub in next, paintedFlat do
        if enabled then
            repaint(texture, true, sub, sub, sub)
        else
            repaint(texture, false, 1, 1, 1)
        end
    end
end

SUI.callbacks.RegisterCallback(Theme, "SettingChanged", function(_, category, key)
    if category == "general" and (key == "theme" or key == "color") then
        Theme:Update()
        Theme:Repaint()
        SUI:NotifyThemeChanged()
    end
end)
