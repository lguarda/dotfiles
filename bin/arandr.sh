#!/usr/bin/env bash

ZENITY_LIST=""
if [ -d $HOME/.screenlayout ];
    for i in $HOME/screenlayout/*;do
        ZENITY_LIST="$ZENITY_LIST $i $(basename --suffix='.sh' $i)";
    done
else
    arandr
    exit 0
fi

RESULT=`zenity --list --title="Choisissez les bogues à afficher" --hide-column=1 --column="script" --column="ScreenLayout" $ZENITY_LIST --extra-button arandr --width=600 --height=400`
if [ "$RESULT" != "" ];then
    if [ "$RESULT" = "arandr" ];then
        arandr
    else
        $RESULT
    fi
fi
