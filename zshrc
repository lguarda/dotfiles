# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=/home/frederic/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vim="nvim"

alias ff="\$HOME/\`cd \$HOME ;~/.fzf/bin/fzf --height=35 --prompt='~/'\`"

setxkbmap -option caps:escape

           preview-up
export FZF_DEFAULT_OPTS="--inline-info -m --history=\"$HOME/.local/share/fzf-history\" --bind=ctrl-x:toggle-sort,ctrl-h:previous-history,ctrl-l:next-history,ctrl-f:jump-accept,alt-j:preview-down,alt-k:preview-up --cycle"

gcdev () {
    local h
    local dir
    local rd
    local cl
    [ $# -eq 1 ] && dir=$1  || dir=. 
    for d in $dir/*(/)
    do
        rd=$(readlink -f $d) 
        if [ -d "$rd/.git" ]
        then
            branch="$(git --git-dir=$rd/.git --work-tree=$rd checkout devlop)" 
            printf "%s\n" "$branch"
        fi
    done
}

gitinfo () {
    local branch
    local h
    local dir
    local rd
    [ $# -eq 1 ] && dir=$1  || dir=. 
    printf "%s                                    : %s %s (%s) \x1b[33m%s\x1b[0m, \x1b[32m%s\x1b[0m, \x1b[31m%s\x1b[0m\n\n" "repo" "branch" "        " " hash " "  M" "  +" "  -"
    for d in $dir/*(/)
    do
        rd=$(readlink -f $d) 
        if [ -d "$rd/.git" ]
        then
            branch="$(git --git-dir=$rd/.git --work-tree=$rd branch | grep \* | cut -d\  -f2-)" 
            h=$(echo $branch | md5sum | cut -d\  -f1 | head -c 2) 
            h=$(( 40 + (16#$h % 80) * 2 )) 
            changed="$(git --git-dir=$rd/.git --work-tree=$rd diff --shortstat | grep -Eo '([0-9]+) files? changed.' | grep -Eo '[0-9]+')" 
            added="$(git --git-dir=$rd/.git --work-tree=$rd diff --shortstat | grep -Eo '([0-9]+) insertion' | grep -Eo '[0-9]+')" 
            deleted="$(git --git-dir=$rd/.git --work-tree=$rd diff --shortstat | grep -Eo '([0-9]+) deletion' | grep -Eo '[0-9]+')" 
            printf "%-40s: \x1b[38;5;%dm%-30s\x1b[0m%s (%.6s) \x1b[33m%3d\x1b[0m, \x1b[32m%3d\x1b[0m, \x1b[31m%3d\x1b[0m\n" "$(basename $rd)" "$h" "$branch" " " "$(git --git-dir=$rd/.git rev-parse HEAD)" "$changed" "$added" "$deleted"
        fi
    done
}

#fetch
gfall () {
    local h
    local dir
    local rd
    local cl
    [ $# -eq 1 ] && dir=$1  || dir=. 
    for d in $dir/*(/)
    do
        rd=$(readlink -f $d) 
        if [ -d "$rd/.git" ]
        then
            cl=$(echo $(basename $rd) | md5sum | cut -d\  -f1 | head -c 2) 
            cl=$(( 40 + (16#$cl % 80) * 2 )) 
            printf "\x1b[38;5;%dm%s\x1b[0m\n" "$cl" "$(basename $rd)"
            h="$(git --git-dir=$rd/.git --work-tree=$rd fetch --all)"
            printf "\x1b[33m%s\x1b[0m\n" "$h"
            printf "=============\n"
        fi
    done
}

#compare distant and local branch
grpall () {
    local head
    local dist
    local dir
    local rd
    local ha
    local cl
    [ $# -eq 1 ] && dir=$1  || dir=. 
    for d in $dir/*(/)
    do
        rd=$(readlink -f $d) 
        if [ -d "$rd/.git" ]
        then
            ha="$(git --git-dir=$rd/.git --work-tree=$rd rev-parse --abbrev-ref HEAD)"
            cl=$(echo $ha | md5sum | cut -d\  -f1 | head -c 2) 
            cl=$(( 40 + (16#$cl % 80) * 2 )) 
            printf "%-30s \x1b[38;5;%dm%-20s\x1b[0m" "$(basename $rd)" "$cl" "$ha"
            head="$(git --git-dir=$rd/.git --work-tree=$rd rev-parse --short $ha)"
            if [ $(git --git-dir=$rd/.git --work-tree=$rd branch --all | grep "remotes/origin/$ha") ] ;then
                dist="$(git --git-dir=$rd/.git --work-tree=$rd rev-parse --short origin/$ha)"
                if [ "$head" = "$dist" ]; then
                    printf "Up to date %13s\n" "- $head"
                else
                    printf "\x1b[31mNOPE       \x1b[0m- \x1b[32m%s \x1b[31m%s\x1b[0m\n" "$dist" "$head"
                fi
            else
                printf "No Dist Branch - %s\n" "$head"
            fi
        fi
    done
}

#compare root branch
gddall () {
    local root
    local last
    local dir
    local rd
    local ha
    [ $# -eq 1 ] && dir=$1  || dir=. 
    for d in $dir/*(/)
    do
        rd=$(readlink -f $d) 
        if [ -d "$rd/.git" ]; then
            ha="$(git --git-dir=$rd/.git --work-tree=$rd rev-parse --abbrev-ref HEAD)"
            cl=$(echo $ha | md5sum | cut -d\  -f1 | head -c 2) 
            cl=$(( 40 + (16#$cl % 80) * 2 )) 
            printf "%-30s \x1b[38;5;%dm%-20s\x1b[0m" "$(basename $rd)" "$cl" "$ha"
            root="$(git --git-dir=$rd/.git --work-tree=$rd merge-base origin/develop $ha)"
            last="$(git --git-dir=$rd/.git --work-tree=$rd rev-parse origin/develop)"
            if [ "$root" = "$last" ]; then
                printf "\x1b[32m OK\x1b[0m\n"
            else
                printf "\x1b[31m Rebase\x1b[0m\n"
            fi
        fi
    done
}

gmb () {
if [ "$#" -eq 2 ];then
    local revHead
    local l1
    local l2
    local len1
    local len2
    local mb1
    local mb2
    local mb1s
    local mb2s
    local hash1
    local hash2

    l1=$(git rev-list $1)
    l2=$(git rev-list $2)

    len1=$(echo $l1 | wc -l)
    len2=$(echo $l2 | wc -l)


    mergeBase=$(git merge-base $1 $2)
    i=0
    git rev-list $1 | 
    while read CMD; do
        if [ $CMD = $mergeBase ];then
            mb1=$i
        fi
        i=$(($i + 1))
    done
    i=0
    git rev-list $2 | 
    while read CMD; do
        if [ $CMD = $mergeBase ];then
            mb2=$i
        fi
        i=$(($i + 1))
    done
    mb1s=$mb1
    mb2s=$mb2
    if [ $mb1 -gt $mb2 ];then
        mb2=$(($mb2 - $mb1))
        mb1=$(($mb1 - $mb1))
    else
        mb1=$(($mb1 - $mb2))
        mb2=$(($mb2 - $mb2))
    fi
    i=0
    while :
    do
        hash1="                                        ";hash2="                                        "
        if [ $mb1 -ge 0 ];then 
            hash1=$(echo -n $(echo $l1 | sed -n $(echo $(($mb1 + 1)))p))
            #echo -n $hash1
        fi
        if [ $mb2 -ge 0 ];then 
            hash2=$(echo -n $(echo $l2 | sed -n $(echo $(($mb2 + 1)))p))
            #echo -n $hash2
        fi
        if [ $hash1 = $hash2 ];then; printf "\x1b[32m%s = %s\x1b[0m\n" "$hash1" "$hash2"
        else printf "\x1b[33m%s ~ %s\x1b[0m\n" "$hash1" "$hash2";fi
        mb1=$(($mb1 + 1)); mb2=$(($mb2 + 1))
        if [ $mb1 -gt $len1 ] && [ $mb2 -gt $len2 ];then; break; fi
    done
fi
}
#tibi stuff
function up-line-or-search-prefix () # smart up search (search in history anything matching before the cursor)
{
    local CURSOR_before_search=$CURSOR
    zle up-line-or-search "$LBUFFER"
    CURSOR=$CURSOR_before_search
}; zle -N up-line-or-search-prefix

function down-line-or-search-prefix () # same with down
{
    local CURSOR_before_search=$CURSOR
    zle down-line-or-search "$LBUFFER"
    CURSOR=$CURSOR_before_search
}; zle -N down-line-or-search-prefix

function c()                    # simple calculator                                                                    
{
    echo $(($@));
}

function d2h()                  # decimal to hexa                                                                      
{
    echo $(( [#16]$1 ));
}

function h2d()                  # hexa to decimal                                                                      
{
    echo $(( 16#$1 ));
}

function d2b()                  # decimal to binary                                                                    
{
    echo $(( [#2]$1 ));
}

function h2b()                  # binary to decimal                                                                    
{
    echo $(( 2#$1 ));
}

function h2b()                  # hexa to binary                                                                       
{
    echo $(( [#2]16#$1 ));
}

function b2h()                  # binary to hexa                                                                       
{
    echo $(( [#16]2#$1 ));
}

function push_plugin()
{
    cp /home/frederic/merge2/build/opsise-pos-plugin* ~/shared/demo/PLUGIN_FR
}

function winshared()
{
    sudo mount -t vboxsf linux ~/shared
}

function cdf() {
   local file
   local dir
   file=$(fzf -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

function cif() {
    local dir
    dir=$(
        find ${1:-$HOME} d -print 2> /dev/null |
        fzf -1 --preview="ls -l --color=always  {-1}" --header-lines=1 --ansi --prompt="${1:-$HOME}"
    ) && cd "$dir"
}

function cf() {
    local dir
    dir=$(
        find ${1:-$HOME} \( ! -regex '.*/\..*' \) -type d -print 2> /dev/null |
        fzf -1 --preview="ls -l --color=always  {-1}" --header-lines=1 --ansi --prompt="${1:-$HOME}"
    ) && cd "$dir"
}

function vif() {
    local dir
    dir=$(
        find ${1:-$HOME} -type f -print 2> /dev/null |
        fzf -1 --preview="pygmentize -g {-1}" --header-lines=1 --ansi --prompt="${1:-$HOME}"
    ) && nvim "$dir"
}

function vf() {
    local dir
    dir=$(
        find ${1:-$HOME} \( ! -regex '.*/\..*' \) -type f -print 2> /dev/null |
        fzf -1 --preview="pygmentize -g {-1}" --header-lines=1 --ansi --prompt="${1:-$HOME}"
    ) && nvim -O $(echo "$dir" | sed ':a;N;$!ba;s/\n/ /g')
}


function lf() {
    local dir
    dir=$(
        find ${1:-$HOME} -type d -print 2> /dev/null |
        fzf -1 --preview="ls -l --color=always  {-1}" --header-lines=1 --ansi --prompt="${1:-$HOME}"
    ) && ls -l "$dir"
}

function caf() {
    local dir
    dir=$(
        find ${1:-$HOME} -type f -print 2> /dev/null |
        fzf -1 --preview="pygmentize -g {-1}" --header-lines=1 --ansi --prompt="${1:-$HOME}"
    ) && pygmentize -g "$dir"
}

# fbr - checkout git branch
function fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}
# fshow - git commit browser
function fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

bindkey "^[[1;5A" up-line-or-search-prefix
bindkey "^[[1;5B" down-line-or-search-prefix


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
