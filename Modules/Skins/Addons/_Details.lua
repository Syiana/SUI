local Skin = SUI:NewModule("Skins.DetailsSUI")

local addonPath = "Interface\\AddOns\\SUI"
local skinName = "|cff00a2ffSUI|r"
local retail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

local function registerTextures()
    if not LibStub then return end
    local LSM = LibStub("LibSharedMedia-3.0", true)
    if not LSM then return end

    LSM:Register("statusbar", "SUI Details Header", addonPath .. "\\Media\\Textures\\DetailsSkin\\header.blp")
    LSM:Register("statusbar", "SUI Details Bar", addonPath .. "\\Media\\Textures\\DetailsSkin\\bar.blp")
    LSM:Register("statusbar", "SUI Details Background", addonPath .. "\\Media\\Textures\\DetailsSkin\\background.blp")
end

local function changeAugmentationBar()
    if not Details or not Details.GetNumInstances or not Details.GetInstance or not Details.class_colors then
        return
    end

    local evokerColor = Details.class_colors["EVOKER"]
    if not evokerColor then
        return
    end

    for instanceId = 1, Details:GetNumInstances() do
        local instance = Details:GetInstance(instanceId)
        if instance and instance.baseframe and instance.ativa and instance.GetAllLines then
            for _, line in ipairs(instance:GetAllLines()) do
                local extraStatusbar = line and line.extraStatusbar
                if extraStatusbar and extraStatusbar.SetStatusBarTexture then
                    extraStatusbar:SetStatusBarTexture(addonPath .. "\\Media\\Textures\\DetailsSkin\\augment.blp")
                    local barTexture = extraStatusbar:GetStatusBarTexture()
                    if barTexture and barTexture.SetVertexColor then
                        barTexture:SetVertexColor(unpack(evokerColor))
                    end
                    if extraStatusbar.texture and extraStatusbar.texture.SetVertexColor then
                        extraStatusbar.texture:SetVertexColor(unpack(evokerColor))
                    end
                end
            end
        end
    end

    local gump = Details.gump
    if not gump then return end

    hooksecurefunc(gump, "CreateNewLine", function(_, instance, index)
        if not instance then return end

        local newLine = _G["DetailsBarra_" .. instance.meu_id .. "_" .. index]
        local extraStatusbar = newLine and newLine.extraStatusbar
        if extraStatusbar and extraStatusbar.SetStatusBarTexture then
            extraStatusbar:SetStatusBarTexture(addonPath .. "\\Media\\Textures\\DetailsSkin\\augment.blp")
            local barTexture = extraStatusbar:GetStatusBarTexture()
            if barTexture and barTexture.SetVertexColor then
                barTexture:SetVertexColor(unpack(evokerColor))
            end
            if extraStatusbar.texture and extraStatusbar.texture.SetVertexColor then
                extraStatusbar.texture:SetVertexColor(unpack(evokerColor))
            end
        end
    end)
end

local skinTable = {
    file = [[Interface\AddOns\Details\images\skins\flat_skin.blp]],
    author = "SUI",
    version = C_AddOns and C_AddOns.GetAddOnMetadata and (C_AddOns.GetAddOnMetadata("SUI", "Version") or "1.0") or "1.0",
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
        titlebar_texture_color = { 0, 0, 0, 1.0 },

        toolbar_icon_file = "Interface\\AddOns\\Details\\images\\toolbar_icons_shadow",
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
            text_color = { NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.a },
            enable_custom_text = false,
            show_timer = true,
        },

        row_info = {
            texture_highlight = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
            fixed_text_color = { 1, 1, 1 },
            height = 28,
            space = { right = 0, left = 0, between = 4 },
            row_offsets = { left = 29, right = -37, top = 0, bottom = 0 },
            texture_background_class_color = false,
            font_face_file = "Interface\\Addons\\Details\\fonts\\Accidental Presidency.ttf",
            backdrop = {
                enabled = false,
                size = 12,
                color = { 1, 1, 1, 1 },
                texture = "Details BarBorder 2",
            },
            icon_file = "Interface\\AddOns\\Details\\images\\classes_small",
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
            texture_custom_file = "Interface\\",
            texture_custom = "",
            alpha = 1,
            no_icon = false,
            texture = "SUI Details Bar",
            texture_file = addonPath .. "\\Media\\Textures\\DetailsSkin\\bar",
            texture_background = "SUI Details Background",
            texture_background_file = addonPath .. "\\Media\\Textures\\DetailsSkin\\background",

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
            spec_file = addonPath .. "\\Media\\Textures\\DetailsSkin\\specs_sui",
            icon_size_offset = 1.2,
        },

        menu_icons_alpha = 1,
        show_statusbar = false,
        menu_icons_size = 1.07,
        color = { 0.333333333333333, 0.333333333333333, 0.333333333333333, 0 },
        bg_r = 0.0941176470588235,
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
        bg_alpha = 0,
        ignore_mass_showhide = false,
        hide_in_combat_alpha = 0,
        menu_icons = { true, true, true, true, true, false, space = 0, shadow = false },
        auto_hide_menu = { left = false, right = false },
        statusbar_info = { alpha = 0, overlay = { 0.333333333333333, 0.333333333333333, 0.333333333333333 } },
        window_scale = 1,
        backdrop_texture = "Details Ground",
        hide_icon = true,
        bg_b = 0.0941176470588235,
        bg_g = 0.0941176470588235,
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

local function setupAfterLogin()
    if not Details or (Details.IsLoaded and not Details.IsLoaded()) then
        if C_Timer and C_Timer.After then
            C_Timer.After(0.2, setupAfterLogin)
        end
        return
    end

    registerTextures()

    if Details.InstallSkin then
        pcall(Details.InstallSkin, Details, skinName, skinTable)
    end

    if Details.GetNumInstances and Details.GetInstance then
        for instanceId = 1, Details:GetNumInstances() do
            local instance = Details:GetInstance(instanceId)
            if instance and instance.baseframe and instance.ativa and instance.ChangeSkin then
                pcall(instance.ChangeSkin, instance)
            end
        end
    end

    if retail then
        changeAugmentationBar()
    end
end

function Skin:OnEnable()
    setupAfterLogin()

    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(_, event, addon)
        if event == "ADDON_LOADED" and addon == "Details" then
            setupAfterLogin()
        end
    end)
end
