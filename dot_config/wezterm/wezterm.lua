local wezterm = require("wezterm")

local config = wezterm.config_builder()

function get_mode()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return "Dark"
end

function get_color_scheme(is_dark_mode)
    if is_dark_mode then
        return "Tokyo Night Storm (Gogh)"
    else
        return "Tokyo Night Day"
    end
end

local mode = get_mode()
local is_dark_mode = mode:find("Dark")
local color_scheme = get_color_scheme(is_dark_mode)

config.font = wezterm.font("Fira Code")
config.font_size = 14.0
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.color_scheme = color_scheme
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
-- config.window_background_opacity = is_dark_mode and 0.75 or 1.0
config.window_background_opacity = 0.9
config.default_cwd = "~/projects"

config.macos_window_background_blur = 10
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.native_macos_fullscreen_mode = false

config.keys = {
    { key = "d", mods = "CMD",       action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "w", mods = "CMD",       action = wezterm.action.CloseCurrentPane({ confirm = true }) },
    { key = "k", mods = "CMD",       action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "j", mods = "CMD",       action = wezterm.action.ActivatePaneDirection("Down") },
    { key = "h", mods = "CMD",       action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "l", mods = "CMD",       action = wezterm.action.ActivatePaneDirection("Right") },
    { key = "K", mods = "CMD",       action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
    { key = "J", mods = "CMD",       action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
    { key = "H", mods = "CMD",       action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
    { key = "L", mods = "CMD",       action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
    { key = "m", mods = "CMD",       action = wezterm.action.ToggleFullScreen },
    { key = " ", mods = "CTRL",      action = wezterm.action.SendKey({ key = " ", mods = "CTRL" }) },
}
config.colors = {
    tab_bar = {
        background = "RGBA(26, 27, 38, 0.75)",
    },
}

return config
