#!/usr/bin/env bash
# Generate the browser userstyles from the active theme's roles.
#
# Every readers/web/<domain>.css is a hand-written style that paints one site
# using --theme-* variables. This script resolves those variables for the active
# theme and writes ~/.local/state/theme/<domain>.user.css.
#
# readers/web/all-sites.css is the one file not named after a domain: it paints
# browser UI that extensions draw into every page, so it is generated without a
# domain rule.
#
# Both files land on the same page and both carry the palette, so a site style
# writes it on ":root:root" to outrank all-sites' ":root". Without that the
# winner is whichever Stylus injects last, and a site keeps the old colors if
# its all-sites copy has drifted.
#
# Install each generated file ONCE in Stylus: open its file:// URL in the
# browser and tick "Live reload" (Stylus needs "Allow access to file URLs").
# After that, every `theme reapply` repaints the site without touching Stylus.
#
# There is deliberately no @updateURL and no version stamping. Stylus rejects an
# update URL that is not http(s), and it does not need one: it remembers the
# file:// address a style was installed from, treats file:// as localhost, and
# compares the code rather than the version. So a regenerated file updates on
# its own, and a run that changes nothing leaves the file byte-identical.
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

THEME_HOME="${THEME_HOME:-$HOME/.config/theme}"
RESOLVE="$THEME_HOME/lib/resolve.sh"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/web"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/theme"

mkdir -p "$STATE_DIR"
[ -d "$SRC_DIR" ] || exit 0

theme="$(bash "$RESOLVE" current-name)"
polarity="$(bash "$RESOLVE" polarity)"

# Each role arrives in four shapes. Use the plain color for fills and borders,
# and the -text one whenever the color is the text itself:
#   --theme-<role>       the color itself
#   --theme-<role>-rgb   an "r, g, b" triplet for rgba(..., .1) shades
#   --theme-<role>-text  the color darkened (or lightened, on a dark theme)
#                        until it is readable ON the page background, keeping
#                        its hue. Several light themes have accents too pale to
#                        read as text, and nord's muted is nearly invisible.
#   --theme-on-<role>    text color to put ON that color: fg or bg, whichever
#                        reads better, falling back to black or white when
#                        neither does. Light themes need this, a bright accent
#                        is too close in brightness to both of them.
#
# Readable means 4.5:1, the WCAG ratio for normal text.
role_vars() {
  bash "$RESOLVE" roles-hex | python3 -c '
import sys

roles = {}
for line in sys.stdin:
    if "=" in line:
        key, value = line.strip().split("=", 1)
        roles[key[len("ROLE_"):].lower()] = value

def luminance(color):
    channels = [int(color[i:i + 2], 16) / 255 for i in (1, 3, 5)]
    channels = [c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
                for c in channels]
    return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2]

def contrast(a, b):
    light, dark = sorted((luminance(a), luminance(b)), reverse=True)
    return (light + 0.05) / (dark + 0.05)

TARGET = 4.5

def channels(color):
    return [int(color[i:i + 2], 16) for i in (1, 3, 5)]

def mix(color, other, amount):
    a, b = channels(color), channels(other)
    return "#" + "".join(f"{round(x + (y - x) * amount):02x}" for x, y in zip(a, b))

def readable_on(color):
    best = max((roles["fg"], roles["bg"]), key=lambda c: contrast(c, color))
    if contrast(best, color) >= TARGET:
        return best
    return max(("#000000", "#ffffff"), key=lambda c: contrast(c, color))

def readable_text(color):
    toward = "#000000" if luminance(roles["bg"]) > 0.5 else "#ffffff"
    for step in range(0, 21):
        candidate = mix(color, toward, step / 20)
        if contrast(candidate, roles["bg"]) >= TARGET:
            return candidate
    return toward

for name, color in roles.items():
    r, g, b = channels(color)
    print(f"    --theme-{name}: {color};")
    print(f"    --theme-{name}-rgb: {r}, {g}, {b};")
    print(f"    --theme-{name}-text: {readable_text(color)};")
    print(f"    --theme-on-{name}: {readable_on(color)};")
'
}

for src in "$SRC_DIR"/*.css; do
  [ -e "$src" ] || continue
  name="$(basename "$src" .css)"
  out="$STATE_DIR/$name.user.css"
  tmp="$STATE_DIR/.$name.user.css.tmp"
  if [ "$name" = "all-sites" ]; then
    scope_open=""
    scope_close=""
    palette_selector=":root"
    describes="Browser UI drawn on top of any page"
  else
    scope_open="@-moz-document domain(\"$name\") {"
    scope_close="}"
    palette_selector=":root:root"
    describes="$name"
  fi
  {
    cat <<HEADER
/* ==UserStyle==
@name           ${name} — terminal
@namespace      ivan.theme
@version        1.0.0
@description    ${describes}, painted with the active terminal theme.
@author         Ivan
==/UserStyle== */

/* Generated by ~/.config/theme (${theme}, ${polarity}) — do not edit.
   Source: ~/.config/theme/readers/web/${name}.css */

${scope_open}
  ${palette_selector} {
HEADER
    role_vars
    echo "  }"
    echo
    cat "$src"
    if [ -n "$scope_close" ]; then echo "$scope_close"; fi
  } > "$tmp"
  mv -f "$tmp" "$out"
  echo "gen-web-usercss: $out"
done
