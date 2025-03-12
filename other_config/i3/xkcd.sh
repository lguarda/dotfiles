#!/bin/bash
cd $HOME/.config/i3/img

imgUrl=$(curl -sL https://c.xkcd.com/random/comic/  | perl -ne '/Image URL.*(https:\/\/.*)$/ and print "$1"')
imgName=$(echo "$imgUrl" | rev | cut -d/ -f1 | rev)
echo $imgUrl
curl -sl "$imgUrl" > "$imgName"
convert "$imgName" -scale 200% "$imgName"
composite -gravity center "$imgName" background.png cache/final.png
rm "$imgName"
