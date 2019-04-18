#!/bin/bash

VAR1="${VAR1:-default value}"

NVIM_CONFIG=${NVIM_CONFIG:-$HOME/.config/nvim}
VIM_CONFIG=${VIM_CONFIG:-$HOME/.vim}
DOTFILES=${DOTFILES:-$HOME/clone/dotfiles}
VIMFILES=${VIMFILES:-$DOTFILES/vim}
DESKTOP_FILES=${VIMFILES:-$DOTFILES/desktop_file}


mkdir -p $NVIM_CONFIG
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share/applications/
ln -sf $DESKTOP_FILES/nvim.desktop $HOME/.local/share/applications/
#ln -sf $DESKTOP_FILES/vim.desktop $HOME/.local/share/applications/
ln -sf $VIMFILES/vimrc $NVIM_CONFIG/init.vim
#ln -sf $VIMFILES/vimrc $HOME/.vim
ln -sf $NVIM_CONFIG $VIM_CONFIG
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage $NVIM_CONFIG
ln -sf $NVIM_CONFIG/nvim.appimage $HOME/.local/bin/nvim
$HOME/.local/bin/nvim +PlugInstall +qall > /dev/null
