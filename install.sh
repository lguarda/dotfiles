#!/bin/bash

# TODO: split vim zsh, and stuf

ME="${0##*/}"
NVIM_CONFIG=$HOME/.config/nvim
VIM_CONFIG=$HOME/.vim
DOTFILES=$HOME/clone/dotfiles

function _usage() {
cat << _END_OF_USAGE_
    Usage: ${ME} OPTIONS...

    Launch a series of unit-test to check the matching functions
    Output should match TAP format (for better integration with Jenkins).

    Options:
    -h, --help      Display this help and exit
    -R, --reverse   Undo everything (carefull rm -rf)
    -f, --fish      Install fish shell

_END_OF_USAGE_
}

while [ -n "$1" ]; do
    case $1 in
        -R|--reverse)
            REVERSE="1"
            ;;
        -f|--fish)
            FISH="1"
            ;;
        -h|--help)
            _usage
            exit 0
            ;;
        *)
            _msg "unknown option '$1'"
            _usage
            exit 1
            ;;
    esac
    shift
done

if [[ $REVERSE -eq "1" ]];then
    rm -rf $NVIM_CONFIG
    rm -rf $VIM_CONFIG
    rm -rf $DOTFILES
    sudo rm /usr/local/bin/nvim #TEMP OR NOT ;)
    rm -rf $HOME/.zshrc #TEMP
    rm -rf $HOME/.oh-my-zsh #TEMP
else

    #install dependency
    if [ -f installDependency.sh ]; then
        bash -e installDependency.sh
    fi


    # Clone repo
    mkdir -p $HOME/clone/
    git clone https://github.com/lguard/dotfiles $DOTFILES
    git --git-dir=clone/dotfiles/.git/ --work-tree=clone/dotfiles/ checkout Rework #TEMP

    # git config
    cat $DOTFILES/gitconfig >> $HOME/.gitconfig

    # Vim/Nvim
    mkdir -p $NVIM_CONFIG
    ln -s $DOTFILES/vimrc $NVIM_CONFIG/init.vim
    ln -s $DOTFILES/vimrc $NVIM_CONFIG/vimrc
    ln -s $NVIM_CONFIG $VIM_CONFIG
    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    chmod u+x nvim.appimage
    mv nvim.appimage $NVIM_CONFIG
    sudo ln -s $NVIM_CONFIG/nvim.appimage /usr/local/bin/nvim
    vim +PlugInstall +qall > /dev/null

    # Zsh/OhMyZsh
    if [ -f ohmyzshInstall.sh ]; then
        bash -e ohmyzshInstall.sh
        rm ~/.zshrc
        ln -s $DOTFILES/zshrc $HOME/.zshrc #TEMP
    fi

    if [[ $FISH -eq "1" ]];then
        # fish
        curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
        fish -c fisher install z fzf pure
    fi
fi
