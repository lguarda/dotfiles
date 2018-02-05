#!/bin/bash

curl https://raw.githubusercontent.com/lguard/dotfiles/master/qvim.vim > /tmp/qvim.vim

read -p "Tempo Vim? y(yes) n(Install to home)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
   export VIMINIT='source $MYVIMRC'
   export MYVIMRC="/tmp/vimrc.tmp.vim"
then
   cp /tmp/qvim.vim ~/.vimtest
fi
$SHELL
