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
    -h, --help       Display this help and exit
    -R, --reverse    Undo everything (carefull rm -rf)
    -f, --fish       Install fish shell
    -s, --standalone clone dotfiles in \$HOME/clone
    -d, --dependency install some dependency with apt
    -g, --gui        install gui component
    -r, --run        change zsh shell and run it

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
        -d|--dependency)
            DEPENDENCY="1"
            ;;
        -s|--standalone)
            STANDALONE="1"
            ;;
        -g|--gui)
            GUI="1"
            ;;
        -r|--run)
            RUN="1"
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
    sudo rm $HOME/.local/bin/nvim
    rm -rf $HOME/.zshrc #TEMP
    rm -rf $HOME/.oh-my-zsh #TEMP
else
    mkdir -p $HOME/clone/
    cd $HOME/clone/dotfiles/

    #install dependency
    if [[ $DEPENDENCY -eq "1" ]];then
        if [ -f installDependency.sh ]; then
            bash -e installDependency.sh
        fi
    fi


    # Clone repo
    if [[ $STANDALONE -eq "1" ]];then
        git clone https://github.com/lguard/dotfiles $DOTFILES
        git --git-dir=clone/dotfiles/.git/ --work-tree=clone/dotfiles/ checkout Rework #TEMP
    fi

    # git config
    cat $DOTFILES/gitconfig >> $HOME/.gitconfig

    # Vim/Nvim
    bash -e neovimapp.sh 

    # bash
    ln -s $DOTFILES/inputrc $HOME/.inputrc

    # Script
    ln -s $DOTFILES/bin/* $HOME/.local/bin/

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

    if [[ $GUI -eq "1" ]];then
        # i3
        bash -e gui.h
        if [[ $DEPENDENCY -eq "1" ]];then
            bash -e installDependencyGui.sh
        fi
    fi

    if [[ $RUN -eq "1" ]];then
        chsh
        zsh
    fi
fi
