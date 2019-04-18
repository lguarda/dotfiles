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

$START_WITH=""
for (( ; ; ))
do
    nmcli -d wifi rescan 2> /dev/null
    IFS=$'\n'
    network=$(nmcli --color yes device wifi | fzf --ansi --reverse --cycle --inline-info --header-lines=1 --print-query --bind "ctrl-r:print-query+abort" --query=$START_WITH)
    [[ -z "$network" ]] && exit
    if [ "$(echo -e "$network" | wc -l)" = "1" ];then
        START_WITH="$network"
        continue
    else
        network=$(echo -e "$network" | tail -n +2)
        network=$(sed -r 's/^\s*\*?\s*//; s/\s*(Ad-Hoc|Infra).*//' <<< "$network")
        echo "connecting to \"${network}\"..."
        nmcli -a device wifi connect "$network"
        exit 0
    fi
done
