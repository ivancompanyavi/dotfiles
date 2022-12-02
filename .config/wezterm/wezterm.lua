local wezterm = require 'wezterm'

function scheme_for_appearance(appearance)
	if appearance:find "Dark" then
    return "tokyonight"
	else
    return "Gruvbox Light"
	end

end

return {
  font = wezterm.font 'Fira Code',
  font_size = 14.0,
  color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
  window_decorations = 'RESIZE',
  enable_tab_bar = false,
  window_background_opacity = 0.9,
  keys = {
    { key = 'd', mods = 'CMD', action = wezterm.action.SplitVertical {domain="CurrentPaneDomain"}},
    { key = 'd', mods = 'CMD|SHIFT', action = wezterm.action.SplitHorizontal {domain="CurrentPaneDomain"}},
    { key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentPane { confirm = true }},
    { key = 'k', mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Up'},
    { key = 'j', mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Down'},
    { key = 'h', mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Left'},
    { key = 'l', mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Right'},
    { key = 'K', mods = 'CMD', action = wezterm.action.AdjustPaneSize { 'Up', 5 }},
    { key = 'J', mods = 'CMD', action = wezterm.action.AdjustPaneSize { 'Down', 5 }},
    { key = 'H', mods = 'CMD', action = wezterm.action.AdjustPaneSize { 'Left', 5 }},
    { key = 'L', mods = 'CMD', action = wezterm.action.AdjustPaneSize { 'Right', 5 }},

  }
}
