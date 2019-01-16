#!/bin/bash

(sleep 1 && xset dpms force standby) &

i3lock -u -i $HOME/.config/i3/img/cache/final2.png

$HOME/.config/i3/xkcd.sh
$HOME/.config/i3/multi.sh
