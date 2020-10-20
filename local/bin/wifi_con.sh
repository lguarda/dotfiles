#!/usr/bin/env bash

has() {
  local verbose=false
  if [[ $1 == '-v' ]]; then
    verbose=true
    shift
  fi
  for c in "$@"; do c="${c%% *}"
    if ! command -v "$c" &> /dev/null; then
      [[ "$verbose" == true ]] && err "$c not found"
      return 1
    fi
  done
}

err() {
  printf '\e[31m%s\e[0m\n' "$*" >&2
}

die() {
  (( $# > 0 )) && err "$*"
  exit 1
}

has -v nmcli fzf || die

WIFI_ENABLED="$(nmcli radio wifi)"

if [ "$WIFI_ENABLED" = "disabled" ];then
    while true; do
        read -p "Wifi is disabled do you wish to enable it? y/n" yn
        case $yn in
            [Yy]* ) nmcli radio wifi on; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    sleep 5
fi

START_WITH=""
for (( ; ; ))
do
    nmcli dev wifi rescan 2> /dev/null
    IFS=$'\n'
    network=$(nmcli --color yes device wifi | fzf --ansi --reverse --cycle --inline-info --header-lines=1) # attempt to reload -> --print-query --bind "ctrl-r:print-query+abort" --query=$START_WITH)
    echo $network
    [[ -z "$network" ]] && exit
    network=$(echo -e "$network" | awk '{print $1}')
    echo "connecting to \"${network}\"..."
    nmcli -a device wifi connect "$network"
    exit 0
done
