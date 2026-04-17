function tv_files_insert
    set -l token (commandline -t)

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

    set -l selected (tv files $dir)

    if test -n "$selected"
        if test -n (commandline -t)
            commandline -rt -- (path normalize "$token/$selected")
        else
            commandline -i -- "$selected"
        end
    end
end
