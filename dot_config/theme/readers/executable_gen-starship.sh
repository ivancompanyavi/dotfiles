#!/usr/bin/env bash
# Generate a themed starship config from the template by substituting role
# tokens ({{ACCENT}}, {{BG}}, …) with the active theme's hex colors. Output is
# a COMPLETE starship config (env.sh points STARSHIP_CONFIG at it).
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

THEME_HOME="${THEME_HOME:-$HOME/.config/theme}"
RESOLVE="$THEME_HOME/lib/resolve.sh"
TEMPLATE="$THEME_HOME/readers/starship.template.toml"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/theme"
OUT="$STATE_DIR/starship.toml"

[ -f "$TEMPLATE" ] || exit 0
mkdir -p "$STATE_DIR"

content="$(cat "$TEMPLATE")"
for role in accent accent2 surface bg fg muted; do
  hex="$(bash "$RESOLVE" role "$role")"
  token="{{$(printf '%s' "$role" | tr '[:lower:]' '[:upper:]')}}"
  content="${content//$token/$hex}"
done
printf '%s\n' "$content" > "$OUT"
