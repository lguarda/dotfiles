#!/bin/bash

# TODO: split vim zsh, and stuf

ME="${0##*/}"
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config/}

NVIM_CONFIG=${NVIM_CONFIG:-$XDG_CONFIG_HOME/nvim}
GIT_CONFIG=${GIT_CONFIG:-$XDG_CONFIG_HOME/git}
VIM_CONFIG=${VIM_CONFIG:-$HOME/.vim}
DOTFILES=${DOTFILES:-$HOME/clone/dotfiles}
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

    Example:
    install via ssh:
    scp install.sh user@127.0.0.1:./
    ssh -t user@127.0.0.1 "./install.sh -s -d -r"

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

RED="\x1b[31m"
GREEN="\x1b[32m"
YELLOW="\x1b[33m"
BLUE="\x1b[34m"
PURPLE="\x1b[35m"
LBLUE="\x1b[36m"
B="\x1b[1m"
NONE="\x1b[0m"

if [[ $REVERSE -eq "1" ]];then
    rm -rf $NVIM_CONFIG
    rm -rf $VIM_CONFIG
    rm -rf $DOTFILES
    rm -f $HOME/.local/bin/nvim
    rm -rf $HOME/.zshrc #TEMP
    rm -rf $HOME/.oh-my-zsh #TEMP
else
    mkdir -p $HOME/clone/
    mkdir -p $HOME/.local
    mkdir -p $HOME/.config

    # Clone repo
    if [[ $STANDALONE -eq "1" ]];then
        printf "$B$LBLUE%s$NONE\n" "======= Clone dotfiles repo ======="
        git clone https://github.com/lguard/dotfiles $DOTFILES
        #git --git-dir=clone/dotfiles/.git/ --work-tree=clone/dotfiles/ checkout Rework #TEMP
    fi

    #install dependency
    if [[ $DEPENDENCY -eq "1" ]];then
        printf "$B$LBLUE%s$NONE\n" "======= install dependency  ======="
        bash -e $DOTFILES/installConf/installDependency.sh
    fi

    SRCDIR=$DOTFILES'/config'
    DSTDIR=$HOME'/.config/'
    (cd $SRCDIR && find . -type f -exec bash -c "CDIR=$DSTDIR\$(dirname {}) && mkdir -p \$CDIR && ln -sf \$(readlink -f {}) \$CDIR/" \;)

    SRCDIR=$DOTFILES'/local'
    DSTDIR=$HOME'/.local/'
    (cd $SRCDIR && find . -type f -exec bash -c "CDIR=$DSTDIR\$(dirname {}) && mkdir -p \$CDIR && ln -sf \$(readlink -f {}) \$CDIR/" \;)

    # Nvim
    printf "$B$LBLUE%s$NONE\n" "=======   insatll neovim    ======="
    bash -e $DOTFILES/installConf/neovimapp.sh

    # Zsh/OhMyZsh
    if [ -f $DOTFILES/installConf/ohmyzshInstall.sh ]; then
        printf "$B$LBLUE%s$NONE\n" "=======   install ohmyzsh   ======="
        bash -e $DOTFILES/installConf/ohmyzshInstall.sh
        rm -f ~/.zshrc
        printf "$B$LBLUE%s$NONE\n" "=======     link zshrc      ======="
        ln -sf $DOTFILES/zshrc $HOME/.zshrc #TEMP
        sudo chsh -s /usr/bin/zsh $USER
    fi

    if [[ $FISH -eq "1" ]];then
        printf "$B$LBLUE%s$NONE\n" "=======    install fish     ======="
        # fish
        curl -Lo $XDG_CONFIG_HOME/fish/functions/fisher.fish --create-dirs https://git.io/fisher
        fish -c fisher install z fzf pure
    fi

    if [[ $GUI -eq "1" ]];then
        # i3
        if [[ $DEPENDENCY -eq "1" ]];then
            printf "$B$LBLUE%s$NONE\n" "=======  install gui deps   ======="
            bash -e $DOTFILES/installConf/installDependencyGui.sh
        fi
    fi

    if [[ $RUN -eq "1" ]];then
        zsh
    fi
fi
