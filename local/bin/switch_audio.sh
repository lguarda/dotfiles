#!/bin/bash

declare -i sinks=(`pacmd list-sinks | perl -ne '/index: (\d)/ && print("$1\n")'`)
declare -i sinks_count=${#sinks[*]}
declare -i active_sink_index=`pacmd list-sink-inputs | perl -ne '/sink: (\d+)/ && print("$1") && exit(0)'`
declare -i next_sink_index=`echo "$active_sink_index % $sinks_count + 1" | bc`

echo "next $next_sink_index, $sinks_count"

#move all inputs to the new sink
for app in $(pacmd list-sink-inputs | perl -ne '/index: (\d+)/ && print("$1\n")');
do
    pacmd "move-sink-input $app $next_sink_index"
done

new_device_name=`pacmd list-sinks  | perl -0777 -ne '/index: '$next_sink_index'.*?device.description = "(.*?)"/gs && print("$1")'`

notify-send -t 1000 -i notification-audio-volume-high -h string:x-canonical-private-synchronous:anything  "Sound output switched to" "$new_device_name"
