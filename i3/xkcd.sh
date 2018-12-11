#!/bin/bash
cd $HOME/.config/i3/img
#i3lock -u -i final_lock.png

#echo "<svg xmlns='http://www.w2.org/2000/svg' width='100' height='100' viewBox='0 0 200 200'><rect fill='#ee5522' width='200' height='200'/><defs><linearGradient id='a' gradientUnits='userSpaceOnUse' x1='100' y1='33' x2='100' y2='-3'><stop offset='0' stop-color='#000' stop-opacity='0'/><stop offset='1' stop-color='#000' stop-opacity='1'/></linearGradient><linearGradient id='b' gradientUnits='userSpaceOnUse' x1='100' y1='135' x2='100' y2='97'><stop offset='0' stop-color='#000' stop-opacity='0'/><stop offset='1' stop-color='#000' stop-opacity='1'/></linearGradient></defs><g fill='#ca481d' fill-opacity='0.6'><rect x='100' width='100' height='100'/><rect y='100' width='100' height='100'/></g><g fill-opacity='0.5'><polygon fill='url(#a)' points='100 30 0 0 200 0'/><polygon fill='url(#b)' points='100 100 0 130 0 100 200 100 200 130'/></g></svg>" | convert -resize 2560x1440 svg:- $HOME/.config/i3/bg.png
#TODO: fetch max comics in xkcd.com
random=$(echo "$RANDOM % 1600" | bc)
imgUrl=$(curl -sL https://xkcd.com/$random | grep "Image URL" | cut -d: -f3)
imgName=$(echo "$imgUrl" | rev | cut -d/ -f1 | rev)
curl -sl "https:$imgUrl" > "$imgName"
convert "$imgName" -scale 200% "$imgName"
composite -gravity center "$imgName" background.png cache/final.png
rm "$imgName"
