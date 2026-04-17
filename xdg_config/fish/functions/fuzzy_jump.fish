function fuzzy_jump
    # set -l dir (tv zoxide --width 40 --inline)
    set -l dir (zoxide query -l | fzf --info=inline --height=30%)
    if test -n "$dir"
        cd $dir
    end
    commandline -f repaint
end
