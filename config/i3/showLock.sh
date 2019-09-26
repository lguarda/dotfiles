#!/bin/bash
cd $HOME/.config/i3
scrot ./img/cache/currentScreen.png

composite -gravity center ./img/vpn-key-512.png ./img/cache/currentScreen.png ./img/cache/screen_lock.png
i3lock -u -i ./img/cache/screen_lock.png
