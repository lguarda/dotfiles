#!/usr/bin/env bash
layout=$(setxkbmap -query | grep layout | cut -d:  -f2 | tr -d " ")

if [ $layout == "us" ];then
    setxkbmap fr
    notify-send -t 100 "Keyboard layout: FR"
else
    setxkbmap us
    notify-send -t 100 "Keyboard layout: US"
fi
