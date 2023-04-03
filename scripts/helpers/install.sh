#!/usr/bin/env bash

_install_check_homebrew() {
  brew list | grep $1 > /dev/null
}

_install_check_npm () {
  npm list -g | grep $1@ > /dev/null
}

_command_exists () {
  type "$1" &> /dev/null ;
}


_install_nvm() {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
}

_tap_item() {
  command=$1
  package=$2

  $command $package > /dev/null 2>$TEMP_LOG
  if [ -s "$TEMP_LOG" ]; then
    echo -e "⛔ Error running command '$command $package':\n$(cat $TEMP_LOG)" > $TEMP_LOG
    cat $TEMP_LOG >> $LOG_FILE;
  fi
  echo " ✓ $package tapped."
}

_install_item() {
  command=$1
  package=$2
  install_check=$3

  if ! ($install_check $package); then
    $command $package > /dev/null 2>$TEMP_LOG
    if [ -s "$TEMP_LOG" ]; then
      echo -e "⛔ Error running command '$command $package':\n$(cat $TEMP_LOG)" > $TEMP_LOG
      cat $TEMP_LOG >> $LOG_FILE;
    fi
    echo " ✓ $package installed."
  else
    echo " ⚠ $package already installed."
  fi
}

_install_npm() {
  install_command="npm install -g"

  echo "- Installing NPM packages"
  for dep in $NPM_DEPS; do
    _install_item "$install_command" $dep _install_check_npm
  done
}

_tap_homebrew() {
  tap_command="brew tap"

  echo "- Tapping homebrew packages"
  for dep in $BREW_TAPS; do
    _tap_item "$tap_command" $dep
  done
}

_install_homebrew() {
  install_command="brew install"

  echo "- Installing homebrew packages"
  for dep in $BREW_DEPS; do
    _install_item "$install_command" $dep _install_check_homebrew
  done
}

_install_fzf_keybinds() {
  $(brew --prefix)/opt/fzf/install
}
_install_oh_my_zsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

_install() {
  rm $TEMP_LOG 2>/dev/null
  rm $LOG_FILE

  touch $LOG_FILE
  _tap_homebrew
  _install_homebrew
  _install_npm
  _install_oh_my_zsh
  _install_fzf_keybinds

}
