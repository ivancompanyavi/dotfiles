# Architecture

How this dotfiles repo is wired. It is managed by [chezmoi](https://chezmoi.io):
the repo is the *source state*, `chezmoi apply` renders it into `~` (the
*target state*). macOS-only.

## Repo layout

| Path | What it is |
|------|-----------|
| `.chezmoidata/*.yaml` | Data files merged into the template namespace. `apps.yaml` → `.apps`, `packages.yaml` → `.packages`. |
| `dot_config/…` | Everything under `~/.config/…` (chezmoi maps `dot_` → `.`). |
| `run_onchange_*.sh.tmpl` | Scripts chezmoi runs **when their rendered content changes** (package install, nvim plugin build). |
| `*.tmpl` | Go-templated files, rendered at `apply` time. Non-`.tmpl` files are copied verbatim. |
| `executable_*` | chezmoi sets the executable bit on the target. |
| `~/.config/chezmoi/chezmoi.toml` | **Machine-local** config (NOT in this repo). Holds per-machine template data — see *Machine profiles*. |

## The app registry (`.chezmoidata/apps.yaml`)

Single source of truth for every swappable, user-facing app. Each entry defines
the app **once**; templates read it so swapping an app is a one-file edit
instead of hunting through aerospace, the manifest, and the theme scripts.

Fields: `cask` (Homebrew cask, auto-installed), `bundleId` (aerospace window
matching), `appName` (`open -a` / `pgrep` / `lsappinfo`), plus per-app extras
(`profileDir` for the browser, `workOnly` for machine-gating).

Consumers (all templates):
- `run_onchange_darwin-install-packages.sh.tmpl` → installs every `.apps.*.cask`
- `dot_config/aerospace/aerospace.toml.tmpl` → launch bindings + `on-window-detected` rules use `.appName` / `.bundleId`
- `dot_config/theme/bin/executable_theme-browser.tmpl` → `.browser.{appName,profileDir}`
- `dot_config/sketchybar/plugins/executable_{slack,telegram}.sh.tmpl` → `.appName` for `lsappinfo`

**To swap the browser (or any app):** edit its entry in `apps.yaml`, then
`chezmoi apply`. The cask installs, aerospace retargets, the theme script
retargets — automatically.

## Packages (`.chezmoidata/packages.yaml` + `run_onchange`)

Non-app packages (CLI tools, fonts, taps) live in `packages.yaml`. The
`run_onchange_darwin-install-packages.sh.tmpl` template renders the list into a
`brew bundle` Brewfile and pipes it to Homebrew. Because it's `run_onchange`, it
only re-runs when the rendered package list changes; `brew bundle` is idempotent
(installs missing, never uninstalls).

⚠️ **Third-party taps** (`felixkratz/formulae`, `nikitabobko/tap`,
`jesseduffield/lazygit`) now require a one-time `brew trust <tap>` per machine
before `brew bundle` will load them.

## Machine profiles

`~/.config/chezmoi/chezmoi.toml` (machine-local, not committed) provides
per-machine template data. This laptop sets:

```toml
[data]
    personal = true
```

Apps tagged `workOnly: true` in `apps.yaml` (Slack, Asana) are skipped by the
installer when `personal = true`, and installed otherwise (the work laptop,
where the flag is unset). Templates use `index`-based lookups so the unset case
never errors.

## Theme system (`dot_config/theme/`)

One command/keybind switches the theme across WezTerm, Neovim, sketchybar,
borders, starship, fzf, lazygit, the browser, and the wallpaper. See
`dot_config/theme/docs/README.md` for the full design; the essentials:

- **Active theme** = a pointer file at `~/.local/state/theme/current` (machine-local, not committed). Polarity (dark/light) follows macOS appearance live.
- **Registry** = `registry/<name>.json`, one per theme, with `dark`/`light` variants. Each variant has a `wezterm` scheme name, an `nvim` spec (`module`/`colorscheme`/`background`/`opts`), and 10 semantic `roles` (bg, surface, fg, muted, accent, accent2, ok, warn, urgent, info).
- **`lib/resolve.sh`** = the resolver. Given the pointer + polarity, emits colors/names in whatever shape a consumer needs (`role accent`, `roles-argb`, `fzf-opts`, `wallpaper`, …). Shell consumers use it; rich tools (WezTerm, Neovim) read the JSON directly in their own language.
- **`bin/theme`** = the CLI. `theme set <name>` writes the pointer and runs `reapply()`, which pushes the new colors to every surface (sketchybar cache + reload, starship/lazygit generators, borders, WezTerm reload, wallpaper, browser accent).
- **Readers** (`readers/`, `bin/theme-*`) = per-tool adapters.

### Browser theming (`bin/theme-browser`, a template)

Chromium reads its `browser.theme.*` prefs **only at launch** and rewrites
`Preferences` on exit — so we can only write while the browser is closed, and
the accent shows on next launch. `theme-browser` writes the active theme's
accent as the Chromium seed color (both `user_color`/`user_color2` +
`is_grayscale`/`is_grayscale2`). Launching via `alt-b` (`theme-browser open`)
always applies the current theme first. Browser identity is baked in from
`apps.yaml`. (Brave respects this; Helium was tried first but forces grayscale
back on after startup — hence the switch to Brave.)

### To add a theme

1. Add the Neovim colorscheme plugin to `dot_config/nvim/nvim-pack-lock.json` (`src` + pinned `rev`).
2. Create `registry/<name>.json` with `dark`+`light` variants: a valid WezTerm built-in `wezterm` scheme name, the `nvim` spec, and the 10 `roles`.
3. (Optional) drop wallpapers in `wallpapers/<name>/`.
4. `chezmoi apply` (rebuilds nvim plugins), then `theme set <name>`.

## Window management & bar

- **AeroSpace** (`dot_config/aerospace/aerospace.toml.tmpl`) — tiling WM. Config is `config-version = 2` (AeroSpace 0.21+). `on-window-detected` rules assign apps to workspaces (1 terminal, 2 browser, 3 editor, 4 Asana, 5 Slack, R catch-all) **but only fire for newly-opened windows** — already-open windows aren't retroactively sorted. `persistent-workspaces` is declared so empty workspaces still show in the bar.
- **sketchybar** (`dot_config/sketchybar/`) — custom menu bar. `themes/layout.sh` = geometry (theme-independent; bar is fully transparent, `BAR_BLUR_RADIUS=0`), `themes/palette.sh` = colors from the active theme. Uses `Hack Nerd Font` for glyphs.

## Gotchas

- **AeroSpace rules ≠ retroactive** — reboots/updates can pile already-open apps onto workspace 1; re-sort manually or reopen the app.
- **Homebrew tap trust** — needed once per machine per third-party tap.
- **Chromium theming is restart-only** — see Browser theming above.
- **`theme` pointer + nvim plugins + wallpapers** are machine-local state, resolved at runtime — not every theme surface updates live (nvim theme *name* changes apply to new sessions).
