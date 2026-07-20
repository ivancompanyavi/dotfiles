# ─────────────────────────────────────────────────────────────────────────────
# Theme shell integration — source this from ~/.zshrc (after starship init).
# Points shell tools (fzf, starship, lazygit) at the active theme. These pick up
# the theme lazily: a new shell / next launch reflects the current theme+polarity
# (running shells are not retro-themed, by design).
# ─────────────────────────────────────────────────────────────────────────────
_THEME_HOME="${THEME_HOME:-$HOME/.config/theme}"
_THEME_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/theme"
_THEME_RESOLVE="$_THEME_HOME/lib/resolve.sh"

# fzf — resolve live so every new shell matches the active theme+polarity.
# Keep the theme colors in a dedicated var and rebuild it (don't append to
# FZF_DEFAULT_OPTS) so re-sourcing ~/.zshrc doesn't stack duplicate --color blocks.
if command -v fzf >/dev/null 2>&1 && [ -x "$_THEME_RESOLVE" ]; then
  _THEME_FZF_COLORS="$(bash "$_THEME_RESOLVE" fzf-opts 2>/dev/null)"
  export FZF_DEFAULT_OPTS="${FZF_BASE_OPTS:-} ${_THEME_FZF_COLORS}"
  unset _THEME_FZF_COLORS
fi

# starship — generate the themed config if missing, then point starship at it.
if command -v starship >/dev/null 2>&1; then
  [ -f "$_THEME_STATE/starship.toml" ] || bash "$_THEME_HOME/readers/gen-starship.sh" >/dev/null 2>&1
  [ -f "$_THEME_STATE/starship.toml" ] && export STARSHIP_CONFIG="$_THEME_STATE/starship.toml"
fi

# lazygit — generate the themed config if missing, then point lazygit at it.
if command -v lazygit >/dev/null 2>&1; then
  [ -f "$_THEME_STATE/lazygit.yml" ] || bash "$_THEME_HOME/readers/gen-lazygit.sh" >/dev/null 2>&1
  [ -f "$_THEME_STATE/lazygit.yml" ] && export LG_CONFIG_FILE="$_THEME_STATE/lazygit.yml"
fi

unset _THEME_HOME _THEME_STATE _THEME_RESOLVE
