#!/bin/bash
cd $HOME/.config/i3
scrot currentScreen.png

composite -gravity center vpn-key-512.png currentScreen.png screen_lock.png
i3lock -u -i screen_lock.png
