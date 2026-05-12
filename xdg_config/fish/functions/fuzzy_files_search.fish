function fuzzy_files_search
    set -l token (commandline -t)
    set -l full (commandline)

    set -f dir "."
    if test -n "$token"
        set -l expanded (realpath -m $token 2>/dev/null)
        set expanded (string replace -r '^~' $HOME $token)

        if test -d "$expanded"
            set -f dir $expanded
        else
            set -l parent (dirname -- $expanded)
            if test -d "$parent"
                set dir $parent
            end
        end
    end

    if string match -rq '^\s*(cd|z|zi)\s+' -- $full
        set mode "d"
    else
        set mode "f"
    end
    # set -l selected (tv files $dir)
    set -l selected (fd -LIt $mode "" $dir | fzf --info=inline --height=30% --bind "ctrl-d:reload(fd -LIt d '' $dir)" --bind "ctrl-f:reload(fd -LIt f '' $dir)")

    if test -n "$selected"
        commandline -rt -- (path normalize "$selected")
    end
    commandline -f repaint
end
