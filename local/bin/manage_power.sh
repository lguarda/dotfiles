#!/bin/bash

result=$(zenity --info --title="power management" \
--text "What do you wana do" \
--ok-label="Nothing" \
--extra-button "poweroff" \
--extra-button "reboot" \
--extra-button "reboot_windows" \
--extra-button "suspend")

if [ "$?" != 1 ]
then
    exit
fi

case "$result" in
    poweroff)
        /usr/sbin/shutdown --poweroff now
        ;;

    reboot)
        systemctl reboot
        ;;

    reboot_windows)
        pkexec /usr/sbin/grub-reboot 2
        #/usr/sbin/reboot
        ;;

    suspend)
        systemctl suspend
        ;;
    *)
        exit 1
esac
