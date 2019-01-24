#!/usr/bin/env bash

h=$(echo $1 | md5sum | head -c 2)
h=$(( 40 + (16#$h % 80) * 2))
printf "\x1b[38;5;%dm%s\x1b[0m" "$h" "$1"
