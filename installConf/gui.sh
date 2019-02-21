#!/bin/bash

DOTFILES=$HOME/clone/dotfiles

mkdir -p $HOME/.config/
mkdir -p $HOME/.config/i3status
mkdir -p $HOME/.config/termit
ln -sf $DOTFILES/i3 $HOME/.config/i3
ln -sf $DOTFILES/i3/i3status.config $HOME/.config/i3status/config
ln -sf $DOTFILES/xsessionrc $HOME/.xsessionrc
ln -sf $DOTFILES/termit.rc.lua $HOME/.config/termit/rc.lua
