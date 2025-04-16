local wezterm = require("wezterm")
-- local theme = require("theme")

-- color_scheme = theme.get_theme(wezterm.gui.get_appearance())

local currentMode = wezterm.gui.get_appearance()
local isDarkMode = currentMode:find("Dark")
local theme = "Everforest Light (Gogh)"
if isDarkMode then
	theme = "Tokyo Night"
end

return {
	font = wezterm.font("Fira Code"),
	font_size = 14.0,
	-- color_scheme = color_scheme,
	color_scheme = theme,
	-- window_decorations = "RESIZE",
	enable_tab_bar = false,
	window_background_opacity = 0.9,
	default_cwd = "~/projects",
	keys = {
		{ key = "d", mods = "CMD", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
		{ key = "k", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "j", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Down") },
		{ key = "h", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "l", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Right") },
		{ key = "K", mods = "CMD", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
		{ key = "J", mods = "CMD", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
		{ key = "H", mods = "CMD", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
		{ key = "L", mods = "CMD", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	},
}
