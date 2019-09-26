#!/usr/bin/env bash

ZENITY_LIST=""
for i in $(vboxmanage list vms | cut -d\" -f2);do
    INFO_VM="$(vboxmanage showvminfo $i | grep Sta | sed -r "s/State: +(.+) \(.+/\1/g" | tr \  "_")"
    ZENITY_LIST="$ZENITY_LIST $i $INFO_VM";
done

RESULT=`zenity --list --title="Choisissez les bogues à afficher" --column="Vms" --column="State" $ZENITY_LIST --width=600 --height=400`
if [ "$RESULT" != "" ];then
    vboxmanage startvm $RESULT
fi
