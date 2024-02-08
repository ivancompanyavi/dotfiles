#!/usr/bin/env bash

dot="$(cd "$(dirname "$0")"; pwd)"

source "$dot"/config.sh
source "$dot"/helpers/utils.sh
source "$dot"/helpers/install.sh
source "$dot"/themes/main.sh

install() {
  _install
}

theme() {
  _theme $1
}


# Check if the function exists (bash specific)
if declare -f "$1" > /dev/null
then
  # call arguments verbatim
  "$@"
else
  # Show a helpful error
  echo "'$1' is not a known function name" >&2
  exit 1
fi
