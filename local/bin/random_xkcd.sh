#!/bin/bash

curl -sL https://c.xkcd.com/random/comic/  | perl -ne '/Image URL.*(https:\/\/.*)$/ and print "$1"'
