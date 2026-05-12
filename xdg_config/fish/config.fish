if not status is-interactive
    return
end

# when log in tty call startx
if status is-login
    if test (tty) = "/dev/tty1"
        exec startx
    end
end

fish_add_path /home/leo/.cargo/bin/
# Commands to run in interactive sessions can go here
#if type -q tv
#    tv init fish | source
#end

if type -q zoxide
    zoxide init fish | source
end

if type -q fzf
    fzf --fish | source
end

set -gx EDITOR "editor.sh"
#alias fshow="tv git-log"

function fshow
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" |
  fzf --no-mouse --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show % | delta --paging always'"
end

function fshowa
  git log --graph --color=always --all\
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" |
  fzf --no-mouse --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show % | delta --paging always'"
end

bind \cj fuzzy_jump
bind \cf fuzzy_files_search

function c  # simple calculator
    math $argv
end

function d2h  # decimal to hexa
    printf '%x\n' $argv[1]
end

function h2d  # hexa to decimal
    printf '%d\n' 0x$argv[1]
end

function d2b  # decimal to binary
    python3 -c "print(bin($argv[1])[2:])"
end

function b2d  # binary to decimal
    printf '%d\n' (python3 -c "print(int('$argv[1]', 2))")
end

function h2b  # hexa to binary
    python3 -c "print(bin(int('$argv[1]', 16))[2:])"
end

function b2h  # binary to hexa
    for i in $argv
        python3 -c "print(hex(int('$i', 2))[2:])"
    end
end

function h2o  # hexa to octal
    printf '%o\n' 0x$argv[1]
end
