#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Theme resolver — the single source of truth for "what does the active theme
# map to right now". Given the pointer (selected theme) + live macOS polarity,
# it reads the JSON registry and emits colors/names in whatever shape a consumer
# needs. Consumed by the shell readers (sketchybar, borders, fzf, starship,
# lazygit, wallpaper) and by the `theme` CLI. Rich tools (WezTerm, Neovim) read
# the registry directly in their own language and don't use this.
#
# Usage: resolve.sh <command> [args]
#   current-name              print the active theme name (pointer or fallback)
#   polarity                  print dark|light (from macOS appearance)
#   roles-hex                 emit ROLE_<X>=#rrggbb shell assignments
#   roles-argb                emit ROLE_<X>=0xffrrggbb  (sketchybar/borders form)
#   role <name>               print one role as #rrggbb
#   role-argb <name>          print one role as 0xffrrggbb
#   field <jq-path>           print variant.<jq-path> (e.g. .wezterm)
#   fzf-opts                  print an --color=... string for FZF_DEFAULT_OPTS
#   wallpaper                 print absolute wallpaper path, or empty if none
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

# Ensure jq/defaults resolve even under sketchybar/launchd's minimal PATH.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

THEME_HOME="${THEME_HOME:-$HOME/.config/theme}"
REGISTRY_DIR="$THEME_HOME/registry"
WALLPAPER_DIR="$THEME_HOME/wallpapers"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/theme"
POINTER="$STATE_DIR/current"
DEFAULT_THEME="tokyonight"
ROLES="bg surface fg muted accent accent2 ok warn urgent info"

# Hardcoded last-resort palette (tokyonight-storm) so GUI surfaces never render
# with empty colors even if the registry is missing entirely.
declare -a FALLBACK=(
  "bg=#1a1b26" "surface=#24283b" "fg=#a9b1d6" "muted=#565f89"
  "accent=#7aa2f7" "accent2=#bb9af7" "ok=#9ece6a" "warn=#e0af68"
  "urgent=#f7768e" "info=#7dcfff"
)
_fallback_role() { local r="$1" kv; for kv in "${FALLBACK[@]}"; do [ "${kv%%=*}" = "$r" ] && { echo "${kv#*=}"; return 0; }; done; return 0; }

current_name() {
  local n
  # Trim whitespace so a manually-corrupted pointer ("  gruvbox  ") still
  # resolves the same way the Lua readers (which trim) do.
  n="$(cat "$POINTER" 2>/dev/null | tr -d '[:space:]' || true)"
  if [ -n "$n" ] && [ -f "$REGISTRY_DIR/$n.json" ]; then echo "$n"; else echo "$DEFAULT_THEME"; fi
}

polarity() {
  if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -qi dark; then echo dark; else echo light; fi
}

_registry_file() {
  local n="$1"
  if   [ -f "$REGISTRY_DIR/$n.json" ];               then echo "$REGISTRY_DIR/$n.json"
  elif [ -f "$REGISTRY_DIR/$DEFAULT_THEME.json" ];   then echo "$REGISTRY_DIR/$DEFAULT_THEME.json"
  else echo ""; fi
}

# Echo the active variant object (JSON). Falls back polarity→other→first.
_variant() {
  local f; f="$(_registry_file "$(current_name)")"
  [ -z "$f" ] && return 1
  jq -e --arg p "$(polarity)" \
     '.variants[$p] // .variants.dark // .variants.light // (.variants | to_entries[0].value)' \
     "$f" 2>/dev/null
}

role() {  # $1 = role name → #rrggbb (with fallback)
  local v out
  if v="$(_variant 2>/dev/null)"; then
    out="$(printf '%s' "$v" | jq -r --arg r "$1" '.roles[$r] // empty' 2>/dev/null)"
  fi
  [ -z "${out:-}" ] && out="$(_fallback_role "$1")"
  echo "$out"
}

role_argb() { local h; h="$(role "$1")"; echo "0xff${h#\#}"; }

_upper() { printf '%s' "$1" | tr '[:lower:]' '[:upper:]'; }
roles_hex()  { local r; for r in $ROLES; do echo "ROLE_$(_upper "$r")=$(role "$r")"; done; }
roles_argb() { local r; for r in $ROLES; do echo "ROLE_$(_upper "$r")=$(role_argb "$r")"; done; }

field() {  # $1 = jq path relative to the variant, e.g. .wezterm
  local v; v="$(_variant 2>/dev/null)" || { echo ""; return; }
  printf '%s' "$v" | jq -r "$1 // empty" 2>/dev/null
}

fzf_opts() {
  # Minimal, theme-driven fzf colors mapped from roles.
  printf -- '--color=bg+:%s,bg:%s,fg:%s,fg+:%s,hl:%s,hl+:%s,border:%s,prompt:%s,pointer:%s,marker:%s,header:%s,info:%s' \
    "$(role surface)" "$(role bg)" "$(role fg)" "$(role fg)" \
    "$(role accent)" "$(role accent2)" "$(role muted)" "$(role accent)" \
    "$(role urgent)" "$(role ok)" "$(role muted)" "$(role muted)"
}

wallpaper() {
  local rel; rel="$(field .wallpaper)"
  [ -z "$rel" ] && return 0
  local abs="$WALLPAPER_DIR/$rel"
  [ -f "$abs" ] && echo "$abs" || true
}

cmd="${1:-}"; shift || true
case "$cmd" in
  current-name) current_name ;;
  polarity)     polarity ;;
  roles-hex)    roles_hex ;;
  roles-argb)   roles_argb ;;
  role)         role "$@" ;;
  role-argb)    role_argb "$@" ;;
  field)        field "$@" ;;
  fzf-opts)     fzf_opts ;;
  wallpaper)    wallpaper ;;
  *) echo "resolve.sh: unknown command '${cmd}'" >&2; exit 2 ;;
esac
