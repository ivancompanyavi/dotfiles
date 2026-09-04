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
theme-slack           # Slack's sidebar colors for the active theme
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
| wallpaper | `resolve.sh wallpaper` + osascript | on switch, random pick from `wallpapers/<theme>/` |
| websites  | `readers/gen-web-usercss.sh` → `~/.local/state/theme/<domain>.user.css` | live, once installed in Stylus (see below) |

The macOS light/dark watcher is a launchd agent
(`~/Library/LaunchAgents/com.ivan.theme.dark-notify.plist`) running `dark-notify`,
which calls `bin/theme-appearance-hook` (→ `theme reapply`) on every flip.

## Adding a theme

1. `registry/<name>.json` — copy an existing one; fill `dark` + `light`:
   - `wezterm`: a built-in WezTerm color-scheme name.
   - `nvim`: `{ plugin, module, colorscheme, background, opts }`.
   - `roles`: the 10 semantic colors as `#rrggbb`.
   - `wallpaper`: leave `""` — wallpapers now come from a folder (below).
2. Add the nvim colorscheme plugin URL to `~/.config/nvim/init.lua` (`vim.pack.add`).
3. (optional) `wallpapers/<name>/` — drop in any images; one is picked at RANDOM
   on each switch. Optional `wallpapers/<name>/dark/` + `/light/` subfolders
   split by polarity. No folder = wallpaper left unchanged.
4. `theme set <name>` — done.

## Slack

Slack is the one surface the theme cannot push to. It stores the theme on its
own servers, which is why it follows you to your phone, so there is no file
here to write and nothing for `theme reapply` to do.

`theme-slack` prints the eight sidebar colors for the active theme and copies
the string to the clipboard. Paste it into Preferences → Appearance → Custom
theme, or set the swatches by hand from the labelled list it prints.

It covers the sidebar only. The message pane follows Slack's own light/dark
setting, and there is no supported way to color it. Changing that would mean
injecting CSS into Slack's Electron bundle, which breaks its signature, breaks
on every Slack update, and on a work machine is a question for whoever manages
the laptop.

## Restyling websites

`readers/web/<domain>.css` holds a hand-written stylesheet for one site, written
against `--theme-*` variables. `gen-web-usercss.sh` resolves those variables for
the active theme and writes `~/.local/state/theme/<domain>.user.css`, a
[usercss](https://github.com/openstyles/stylus/wiki/Usercss) file.

The browser side is the [Stylus](https://github.com/openstyles/stylus)
extension. Chromium has no `userContent.css`, so Stylus is what loads a local
stylesheet into a page. Set it up once:

1. Install Stylus.
2. Right-click its icon → **Manage extension** → turn on **Allow access to file
   URLs**.
3. Open `file:///Users/<you>/.local/state/theme/<domain>.user.css`, tick **Live
   reload**, click **Install style**.

**Live reload only runs while that install tab is open**, which is Stylus's own
wording: "Keep this tab open to auto-update the style on external changes."

You do not need it, though. Stylus remembers the `file://` address a style came
from and its autoupdate handles `file://` fine: it treats local files as
localhost, so it compares the code rather than the version and re-applies
whenever the file differs. The catch is the schedule, 24 hours by default.
Options, pick one:

- Set "Userstyle autoupdate interval in hours" to `1` in Stylus options.
- After switching a theme, hit "Check all styles for updates" on Stylus's
  Manage page for an instant refresh.
- Keep the install tabs pinned with live reload on, if you want it immediate
  and hands-off.

Adding a site is one file: `readers/web/<domain>.css`, named after the domain it
targets (the generator turns the file name into the `@-moz-document domain(...)`
rule). Install the generated file in Stylus the same way.

`readers/web/all-sites.css` is the exception to the naming rule. It is generated
without a domain rule, so it applies everywhere, and it holds the browser UI
that extensions draw on top of any page. Right now that is Vimium's link hints,
painted in theme colors instead of Vimium's yellow. It needs its own install in
Stylus, same three steps.

Sites covered today: `youtube.com` (home and watch pages) and `reddit.com`
(feed and comments).

Three things to keep in mind when styling a page:

- Extensions inject their own elements into it. Vimium hangs its hint container
  off `<html>`, so keep site rules scoped to the site's own root element
  (`ytd-app` on YouTube, `body` on Reddit) instead of using bare `span` or `a`.
- Parts of a site can live in shadow DOM, where element rules do not reach.
  Reddit's header, search bar and left nav are like that. Custom properties do
  inherit through the boundary, so remapping the site's own color tokens is the
  way in. Shapes are not reachable at all, which is why Reddit's search field
  stays a rounded pill.
- Anything inside an iframe is out of reach entirely (Vimium's HUD and
  vomnibar, for example).

Sites change their markup, so expect a rule to stop matching now and then.

## Notes / caveats

- **Wallpapers**: each switch picks a RANDOM image from `wallpapers/<theme>/`.
  The curated per-theme pools ARE committed; the big source library
  `wallpapers/_packs/` (~278 MB, e.g. the full gruvbox pack) is git-ignored —
  curate from it into a theme folder. A theme with no folder leaves the current
  wallpaper unchanged (by design), so switching to one without images keeps
  whatever was there. Currently only `gruvbox` has a pool.
- The pointer and all `~/.local/state/theme/*` artifacts are regenerated; safe
  to delete.
