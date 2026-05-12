#!/usr/bin/env bash

# this script take no argument
# call once it will put brightness at 1% and store previous brightness
# on second call it restore this brightness

if ! which brightnessctl; then
    return 0
fi

path=/run/user/$UID/saved_brightness

if [ -f ${path} ]; then
    brightnessctl set $(cat $path)
    rm $path
else
    brightnessctl get > $path
    brightnessctl set '1%'
fi

