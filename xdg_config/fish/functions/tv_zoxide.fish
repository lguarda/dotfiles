function tv_zoxide
    set -l dir (tv zoxide --width 40 --inline)
    if test -n "$dir"
        cd $dir
    end
    commandline -f repaint
end
