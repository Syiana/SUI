-- luacheck config for SUI. WoW's API is huge, so undefined global *reads*
-- are not reported here (W113). Setting globals is reported: SUI must not
-- leak globals except the few listed below.
std = "lua51"
max_line_length = false
self = false
unused_args = false
ignore = {
    "113",  -- accessing undefined global (WoW API)
    "212",  -- unused argument
    "432",  -- shadowing upvalue argument (self in nested hooks)
}
globals = {
    "SUI", "SUI_Options", "SUIConfigWindow",
    "StaticPopupDialogs", "SlashCmdList", "UISpecialFrames",
    "BINDING_HEADER_SUI",
    "GetMinimapShape", -- minimap convention read by LibDBIcon and other minimap add-ons
}
exclude_files = { "Libs/", "_legacy/" }
