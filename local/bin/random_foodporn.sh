#!/usr/bin/env bash

page=$(($RANDOM % 60 + 1)) # fooporn daly max page number)
food_list=$(curl -s "http://foodporndaily.com/explore/food/page/$page/" | perl -ne '/img src="(http:\/\/foodporndaily\.com\/pictures.*?)"/ and print "$1\n"')
list_size=$(echo -e "$food_list" | wc -l)

list_index=$(($RANDOM % $list_size + 1))
echo -e "$(echo -e "$food_list" | head -n$list_index | tail -n1)"
