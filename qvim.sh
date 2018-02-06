#!/bin/bash

QUICKVIMRC="curl https://raw.githubusercontent.com/lguard/dotfiles/master/qvim.vim > /tmp/qvim.vim"
COMPLETEVIMRC="curl https://raw.githubusercontent.com/lguard/dotfiles/master/vimrc > /tmp/vimrc.vim"
VIMPLUG="curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /tmp/plug.vim"

read -p "Tempo Vim? y(yes) n(Install to home)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
   $QUICKVIMRC
   export VIMINIT='source $MYVIMRC'
   export MYVIMRC="/tmp/vimrc.tmp.vim"
   $SHELL
then
   read -p "Complete vim? y(yes) n(Quick config)" -n 1 -r
   echo
   if [[ $REPLY =~ ^[Yy]$ ]]
      $COMPLETEVIMRC
      $VIMPLUG
      mkdir -p ~/.vim/autoload
      cp /tmp/plug.vim ~/.vim/autoload/plug.vim
      cp /tmp/vimrc.vim ~/.vimrc
   then
      $QUICKVIMRC
      cp /tmp/qvim.vim ~/.vimrc
   fi
fi
