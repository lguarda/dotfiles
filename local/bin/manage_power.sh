#!/bin/bash

result=$(zenity --info --title="power management" \
--text "What do you wana do" \
--ok-label="Nothing" \
--extra-button "poweroff" \
--extra-button "suspend")

if [ "$?" != 1 ]
then
    exit
fi

if [ "$result" = "poweroff" ]
then
    /usr/sbin/shutdown --poweroff
elif [ "$result" = "suspend" ]
then
    systemctl suspend
fi
