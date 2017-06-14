#!/bin/zsh

curl -sL http://lesjoiesducode.fr/random > ~/.i3/qwe

pcregrep -M  '<h1 class=\"blog-post-title\">(.|\n)*<\/h1>' ~/.i3/qwe | tail -n +2 | head -n +2 | sed -r "s/\s\s//g" | sed '/^$/d'
cat ~/.i3/qwe | grep '<div class="blog-post-content">' -A 1 | grep http | cut -d\" -f4