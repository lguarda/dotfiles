#!/bin/bash

RED=4:1:1
GREEN=1.5:4:1
PURPLE=1.5:1:4
ORANGE=4:1.5:1
BLUE=1:1:4

if [[ "$1" = "on" ]]; then
  echo Making screen red
  COLOR="echo \$$2"
  GAMMA=`eval $COLOR`
elif [[ "$1" = "off" ]]; then
  echo Making screen normal
  GAMMA=1:1:1
else
  echo Requires one of: "on", "off"
  exit 128
fi

for output in $(xrandr --prop | grep \ connected | cut -d\  -f1); do
  xrandr --output $output --gamma $GAMMA
done
