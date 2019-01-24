#!/usr/bin/env bash

# highlight word with fluo color (196-215)

SED_COMMAND=''
for var in "$@"
do
    h=$(echo $var | md5sum | head -c 2)
    h=$((16#$h % (17-49) + 49))
    SED_COMMAND="${SED_COMMAND}s/($var)/\x1b[1;38;5;${h}m\1\x1b[0m/g; "
done

cat "/dev/stdin" | sed -r "$SED_COMMAND"
