# Theme system

One command / keybind switches the theme across **WezTerm, Neovim, sketchybar,
aerospace borders, starship, fzf, lazygit**, and (best-effort) the wallpaper.
Light/dark follows macOS automatically within the chosen theme.

## Usage

```
theme                 # fzf picker (also: alt-shift-t → floating WezTerm picker)
theme set gruvbox     # switch directly (also: `theme gruvbox`)
theme current         # active theme name
theme list            # available themes
theme reapply         # re-resolve current theme for current polarity
theme polarity        # dark | light (from macOS)
```

Themes: `tokyonight`, `gruvbox`, `catppuccin`, `rose-pine`.

## How it works

- **Source of truth:** JSON registry at `registry/<name>.json`. Each theme has a
  `dark` and `light` variant; each variant carries native names for the rich
  tools (`wezterm` scheme, `nvim` colorscheme/plugin/opts) plus a semantic
  **role palette** (`bg surface fg muted accent accent2 ok warn urgent info`).
- **Active theme:** a single pointer file
  `~/.local/state/theme/current` (machine-local **state**, NOT committed).
  Missing → falls back to `tokyonight`.
- **Polarity:** read live from macOS (`AppleInterfaceStyle`). The theme *name*
  is chosen by you; the light/dark *variant* follows the system.
- **Resolver:** `lib/resolve.sh` maps (pointer + polarity) → colors/names in
  whatever shape a consumer needs. Rich tools (WezTerm, Neovim) read the JSON
  directly in their own language.

### Per-surface behaviour

| Surface   | Reader | Reloads |
|-----------|--------|---------|
| WezTerm   | `readers/wezterm_theme.lua` (required from `~/.config/wezterm/wezterm.lua`) | live — watches the pointer + native macOS-appearance reeval |
| Neovim    | `~/.config/nvim/lua/ivan/theme.lua` | theme name: new sessions / `:ThemeReload`. Polarity: live via auto-dark-mode.nvim |
| sketchybar| `~/.config/sketchybar/themes/palette.sh` (+ `layout.sh` geometry) | `theme reapply` → `sketchybar --reload` |
| borders   | `bin/theme-borders` | live (JankyBorders re-invoke) |
| starship  | `readers/gen-starship.sh` → `~/.local/state/theme/starship.toml` | next shell (`STARSHIP_CONFIG`) |
| fzf       | `shell/init.zsh` → `FZF_DEFAULT_OPTS` | next shell |
| lazygit   | `readers/gen-lazygit.sh` → `~/.local/state/theme/lazygit.yml` | next launch (`LG_CONFIG_FILE`) |
| wallpaper | `resolve.sh wallpaper` + osascript | on switch, only if a wallpaper is mapped |

The macOS light/dark watcher is a launchd agent
(`~/Library/LaunchAgents/com.ivan.theme.dark-notify.plist`) running `dark-notify`,
which calls `bin/theme-appearance-hook` (→ `theme reapply`) on every flip.

## Adding a theme

1. `registry/<name>.json` — copy an existing one; fill `dark` + `light`:
   - `wezterm`: a built-in WezTerm color-scheme name.
   - `nvim`: `{ plugin, module, colorscheme, background, opts }`.
   - `roles`: the 10 semantic colors as `#rrggbb`.
   - `wallpaper`: path relative to `wallpapers/`, or `""` for none.
2. Add the nvim colorscheme plugin URL to `~/.config/nvim/init.lua` (`vim.pack.add`).
3. `theme set <name>` — done.

## Notes / caveats

- **Wallpapers** live locally under `wallpapers/` but are **git-ignored**
  (~278 MB). A fresh machine won't set a wallpaper until you add images; theme
  switching is unaffected. Switching to a theme with no mapped wallpaper leaves
  the current wallpaper unchanged (by design).
- The pointer and all `~/.local/state/theme/*` artifacts are regenerated; safe
  to delete.
