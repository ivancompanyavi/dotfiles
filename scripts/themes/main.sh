#!/usr/bin/env bash

THEME_FOLDER="$dot/themes/$2"

_set_wallpaper() {
  theme=$1
  echo $THEME_FOLDER
  osascript<<END
tell application "System Events"
    tell every desktop
        set picture to "$THEME_FOLDER/wallpaper.jpg"
    end tell
end tell
END
}

_set_neovim() {
  echo "Setting theme for Neovim"
  cp "$THEME_FOLDER/nvim.lua" ~/.config/nvim/lua/user/theme.lua
}

_dark_mode_on() {
  osascript<<END
  tell application "System Events"
    tell appearance preferences
      set dark mode to true
    end tell
  end tell
END
}

_toggle_dark_mode() {
  osascript<<END
  tell application "System Events"
    tell appearance preferences
      set dark mode to not dark mode
    end tell
  end tell
END
}

_set_wezterm() {
  echo "Setting theme for Wezterm"
  cp "$THEME_FOLDER/wezterm.lua" ~/.config/wezterm/theme.lua
}

_set_sketchybar() {
  echo "Setting theme for Sketchybar"
  cp "$THEME_FOLDER/Sketchybar.sh" ~/.config/sketchybar/colors.sh
}

_theme() {
  theme=$1
  if ! exists_in_list "$THEME_LIST" " " $theme; then
    echo "Error: theme '$theme' not supported."
    return 1
  fi

  _set_wallpaper $theme
  _set_neovim $theme
  _set_wezterm $theme
  # _set_sketchybar $theme
  # brew services restart sketchybar

}
