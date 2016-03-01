setxkbmap -option caps:escape

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

bindkey "^[[1;5A" up-line-or-search-prefix
bindkey "^[[1;5B" down-line-or-search-prefix
