#!/bin/bash

ME="${0##*/}"
NVIM_CONFIG=$HOME/.config/nvim
VIM_CONFIG=$HOME/.vim
DOTFILES=$HOME/clone/dotfiles


mkdir -p $NVIM_CONFIG
mkdir -p $HOME/.local/bin
ln -s $DOTFILES/vimrc $NVIM_CONFIG/init.vim
ln -s $DOTFILES/vimrc $NVIM_CONFIG/vimrc
ln -s $NVIM_CONFIG $VIM_CONFIG
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage $NVIM_CONFIG
sudo ln -s $NVIM_CONFIG/nvim.appimage $HOME/.local/bin/nvim
$HOME/.local/bin/nvim +PlugInstall +qall > /dev/null