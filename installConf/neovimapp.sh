#!/bin/bash

NVIM_CONFIG=${NVIM_CONFIG:-$HOME/.config/nvim}

curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage $NVIM_CONFIG
ln -sf $NVIM_CONFIG/nvim.appimage $HOME/.local/bin/nvim
$HOME/.local/bin/nvim +PlugInstall +qall > /dev/null
