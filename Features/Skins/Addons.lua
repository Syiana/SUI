--[[
    SUI 2.0 - Features/Skins/Addons.lua

    Skins for third-party add-ons. Each is its own feature and only runs
    while that add-on is loaded. Bartender4 and ClassicUI get their art
    tinted with the theme; Details! gets an "SUI" entry in its skin list
    that uses the textures in Media/Textures/DetailsSkin.
]]

local _, ns = ...
local SUI = ns.SUI

local S = ns.Skins
local IsAddOnLoaded = SUI.Compat.IsAddOnLoaded

-- Tint-only add-on skins -------------------------------------------------------------
local function tintSkin(id, addon, key, paths)
    local F = SUI:NewFeature(id, {
        category = "skins",
        toggle = function(db)
            return db[key] and IsAddOnLoaded(addon)
        end,
        reload = true,
    })
    -- 1.x coloured these with a plain SetVertexColor (no desaturation)
    local group = { addon = addon, tint = paths }
    function F:OnEnable()
        if not self.registered then
            self.registered = true
            S.Register(self, { group })
        end
    end
end

tintSkin("Skins.Bartender", "Bartender4", "bartender", {
    "BT4StatusBarTrackingManager.SingleBarLarge", "BT4StatusBarTrackingManager.SingleBarSmall",
    "BT4StatusBarTrackingManager.SingleBarLargeUpper", "BT4StatusBarTrackingManager.SingleBarSmallUpper",
    "BlizzardArtLeftCap", "BlizzardArtRightCap",
    "BlizzardArtTex0", "BlizzardArtTex1", "BlizzardArtTex2", "BlizzardArtTex3",
})

tintSkin("Skins.ClassicUI", "ClassicUI", "classicui", {
    "MainMenuBarArtFrameBackground.BackgroundLarge2",
    "MainMenuBarArtFrameBackground.BagsArt",
    "MainMenuBarArtFrameBackground.MicroButtonArt",
})

-- Details! ------------------------------------------------------------------------------
local D = SUI:NewFeature("Skins.Details", {
    category = "skins",
    toggle = function(db)
        return db.details and IsAddOnLoaded("Details")
    end,
    reload = true,
})

local SKIN_NAME = "|cff00a2ffSUI|r"
local media = SUI.mediaPath .. [[Textures\DetailsSkin\]]

local function skinTable()
    local gold = NORMAL_FONT_COLOR
    return {
        file = [[Interface\AddOns\Details\images\skins\flat_skin.blp]],
        author = "SUI",
        version = SUI.version or "2.0",
        site = "https://github.com/Syiana/SUI",
        desc = "SUI Details Skin",
        no_cache = true,

        micro_frames = { color = { 1, 1, 1, 1 }, font = "Accidental Presidency", size = 10, textymod = 1 },

        can_change_alpha_head = true,
        icon_anchor_main = { -1, -5 },
        icon_anchor_plugins = { -7, -13 },
        icon_plugins_size = { 19, 18 },
        icon_point_anchor = { -37, 0 },
        left_corner_anchor = { -107, 0 },
        right_corner_anchor = { 96, 0 },
        icon_point_anchor_bottom = { -37, 12 },
        left_corner_anchor_bottom = { -107, 0 },
        right_corner_anchor_bottom = { 96, 0 },
        icon_on_top = true,
        icon_ignore_alpha = true,
        icon_titletext_position = { 3, 3 },

        instance_cprops = {
            titlebar_shown = true,
            titlebar_height = 32,
            titlebar_texture = "SUI Details Header",
            titlebar_texture_color = { 0, 0, 0, 1 },
            toolbar_icon_file = [[Interface\AddOns\Details\images\toolbar_icons_shadow]],
            toolbar_side = 1,
            menu_anchor = { 10, 10, side = 2 },
            attribute_text = {
                enabled = true,
                shadow = false,
                side = 1,
                text_size = 13,
                custom_text = "{name}",
                text_face = "Friz Quadrata TT",
                anchor = { -4, 10 },
                text_color = { gold.r, gold.g, gold.b, gold.a },
                enable_custom_text = false,
                show_timer = true,
            },
            row_info = {
                texture_highlight = [[Interface\FriendsFrame\UI-FriendsList-Highlight]],
                fixed_text_color = { 1, 1, 1 },
                height = 28,
                space = { right = 0, left = 0, between = 4 },
                row_offsets = { left = 29, right = -37, top = 0, bottom = 0 },
                texture_background_class_color = false,
                font_face_file = [[Interface\Addons\Details\fonts\Accidental Presidency.ttf]],
                backdrop = { enabled = false, size = 12, color = { 1, 1, 1, 1 }, texture = "Details BarBorder 2" },
                icon_file = [[Interface\AddOns\Details\images\classes_small]],
                start_after_icon = false,
                icon_offset = { -30, 0 },
                textL_show_number = true,
                textL_outline = false,
                textL_enable_custom_text = false,
                textL_custom_text = "{data1}. {data3}{data2}",
                textL_class_colors = false,
                textR_outline = false,
                textR_bracket = "(",
                textR_enable_custom_text = false,
                textR_custom_text = "{data1} ({data2}, {data3}%)",
                textR_class_colors = false,
                textR_show_data = { true, true, true },
                fixed_texture_color = { 0, 0, 0 },
                texture_custom_file = [[Interface\]],
                texture_custom = "",
                alpha = 1,
                no_icon = false,
                texture = "SUI Details Bar",
                texture_file = media .. "bar",
                texture_background = "SUI Details Background",
                texture_background_file = media .. "background",
                fixed_texture_background_color = { 0, 0, 0, 1 },
                font_face = "Friz Quadrata TT",
                font_size = 11,
                textL_offset = 0,
                text_yoffset = 7,
                texture_class_colors = true,
                percent_type = 1,
                fast_ps_update = false,
                textR_separator = ",",
                use_spec_icons = true,
                spec_file = media .. "specs_sui",
                icon_size_offset = 1.2,
            },
            menu_icons_alpha = 1,
            show_statusbar = false,
            menu_icons_size = 1.07,
            color = { 1 / 3, 1 / 3, 1 / 3, 0 },
            bg_r = 0.0941176470588235,
            bg_g = 0.0941176470588235,
            bg_b = 0.0941176470588235,
            bg_alpha = 0,
            hide_out_of_combat = false,
            color_buttons = { 1, 1, 1, 1 },
            skin_custom = "",
            menu_anchor_down = { 16, -3 },
            micro_displays_locked = true,
            row_show_animation = { anim = "Fade", options = {} },
            tooltip = { n_abilities = 3, n_enemies = 3 },
            show_sidebars = false,
            instance_button_anchor = { -27, 1 },
            plugins_grow_direction = 1,
            menu_alpha = { enabled = false, onleave = 1, ignorebars = false, iconstoo = true, onenter = 1 },
            micro_displays_side = 2,
            grab_on_top = false,
            strata = "LOW",
            bars_grow_direction = 1,
            ignore_mass_showhide = false,
            hide_in_combat_alpha = 0,
            menu_icons = { true, true, true, true, true, false, space = 0, shadow = false },
            auto_hide_menu = { left = false, right = false },
            statusbar_info = { alpha = 0, overlay = { 1 / 3, 1 / 3, 1 / 3 } },
            window_scale = 1,
            backdrop_texture = "Details Ground",
            hide_icon = true,
            desaturated_menu = false,
            wallpaper = {
                enabled = false,
                texcoord = { 0, 1, 0, 0.7 },
                overlay = { 1, 1, 1, 1 },
                anchor = "all",
                height = 114.0425,
                alpha = 0.5,
                width = 283.0001,
            },
            stretch_button_side = 1,
            bars_sort_direction = 1,
        },
    }
end

-- Retail: the augmentation evoker's extra bar gets its own texture in evoker colour.
local function styleExtraBar(line, color)
    local bar = line and line.extraStatusbar
    if not (bar and bar.SetStatusBarTexture) then
        return
    end
    bar:SetStatusBarTexture(media .. "augment.blp")
    local texture = bar:GetStatusBarTexture()
    if texture then
        texture:SetVertexColor(color[1], color[2], color[3])
    end
    if bar.texture then
        bar.texture:SetVertexColor(color[1], color[2], color[3])
    end
end

local function eachInstance(fn)
    for id = 1, Details:GetNumInstances() do
        local instance = Details:GetInstance(id)
        if instance and instance.baseframe and instance.ativa then
            fn(instance)
        end
    end
end

function D:Install()
    local LSM = LibStub("LibSharedMedia-3.0")
    LSM:Register("statusbar", "SUI Details Header", media .. "header.blp")
    LSM:Register("statusbar", "SUI Details Bar", media .. "bar.blp")
    LSM:Register("statusbar", "SUI Details Background", media .. "background.blp")

    pcall(Details.InstallSkin, Details, SKIN_NAME, skinTable())
    eachInstance(function(instance)
        if instance.ChangeSkin then
            pcall(instance.ChangeSkin, instance)
        end
    end)

    local color = SUI.IsRetail and Details.class_colors and Details.class_colors.EVOKER
    if not color then
        return
    end
    eachInstance(function(instance)
        if instance.GetAllLines then
            for _, line in ipairs(instance:GetAllLines()) do
                styleExtraBar(line, color)
            end
        end
    end)
    S.Hook(self, Details.gump, "CreateNewLine", function(_, instance, index)
        if instance then
            styleExtraBar(_G["DetailsBarra_" .. instance.meu_id .. "_" .. index], color)
        end
    end)
end

-- Details finishes its own setup a moment after login; wait for it.
function D:OnEnable()
    if self.installed then
        return
    end
    local details = Details
    if not (details and details.InstallSkin and details.GetNumInstances) or (details.IsLoaded and not details.IsLoaded()) then
        self:After(0.2, function()
            D:OnEnable()
        end)
        return
    end
    self.installed = true
    self:Install()
end
