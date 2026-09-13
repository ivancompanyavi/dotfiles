local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Theme integration ─────────────────────────────────────────────────────────
-- The active theme is a pointer file written by `~/.config/theme/bin/theme`.
-- The reader below looks up the matching WezTerm color scheme for the current
-- theme + macOS appearance. Make it importable (it lives outside WezTerm's
-- default config dir), then re-resolve on every config load. The theme switcher
-- touches this file to force a reload, so switching a theme repaints WezTerm.
package.path = os.getenv("HOME") .. "/.config/theme/readers/?.lua;" .. package.path
local theme = require("wezterm_theme")

local function apply_theme(cfg)
    local appearance = (wezterm.gui and wezterm.gui.get_appearance()) or "Dark"
    local spec = theme.spec(appearance)
    cfg.color_scheme = spec.color_scheme
    cfg.colors = cfg.colors or {}
    cfg.colors.tab_bar = cfg.colors.tab_bar or {}
    cfg.colors.tab_bar.background = spec.tab_bar_bg
end

config.font = wezterm.font("Fira Code")
config.font_size = 14.0
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.window_background_opacity = 0.9
config.default_cwd = "~/projects"

config.macos_window_background_blur = 10
-- macOS: resizable, no title bar. Linux: no decorations at all; Hyprland draws
-- the borders and handles resizing (on Wayland, "RESIZE" still gets WezTerm's
-- own title bar with maximize/close buttons).
config.window_decorations = wezterm.target_triple:find("darwin") and "RESIZE" or "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.native_macos_fullscreen_mode = false

-- Pane bindings: CMD on macOS, ALT on Linux, which is the same physical key on a
-- PC keyboard. Super belongs to Hyprland, and plain Ctrl+letter to the programs
-- in the shell (Ctrl+D, Ctrl+W, ...); Alt only costs a few readline word edits.
local is_mac = wezterm.target_triple:find("darwin") ~= nil
local MOD = is_mac and "CMD" or "ALT"
local MOD_SHIFT = MOD .. "|SHIFT"

config.keys = {
    { key = "d", mods = MOD,       action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "d", mods = MOD_SHIFT, action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "w", mods = MOD,       action = wezterm.action.CloseCurrentPane({ confirm = true }) },
    { key = "k", mods = MOD,       action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "j", mods = MOD,       action = wezterm.action.ActivatePaneDirection("Down") },
    { key = "h", mods = MOD,       action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "l", mods = MOD,       action = wezterm.action.ActivatePaneDirection("Right") },
    { key = "K", mods = MOD,       action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
    { key = "J", mods = MOD,       action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
    { key = "H", mods = MOD,       action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
    { key = "L", mods = MOD,       action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
    { key = "m", mods = MOD,       action = wezterm.action.ToggleFullScreen },
    { key = " ", mods = "CTRL",    action = wezterm.action.SendKey({ key = " ", mods = "CTRL" }) },
}

if not is_mac then
    -- Tabs: CMD+T and CMD+1..9 are WezTerm defaults on macOS; give Linux the same
    -- on ALT. Ctrl+Shift+T and Ctrl+Shift+1..9 keep working as Linux's defaults.
    table.insert(config.keys, { key = "t", mods = "ALT", action = wezterm.action.SpawnTab("CurrentPaneDomain") })
    for i = 1, 9 do
        table.insert(config.keys, { key = tostring(i), mods = "ALT", action = wezterm.action.ActivateTab(i - 1) })
    end
end

-- Resolve and apply the active theme last, so it wins over any static colors.
apply_theme(config)

return config
