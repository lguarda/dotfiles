#!/bin/bash

if [ "$#" -eq 1 ]; then
	curl -fLo ~/.nvim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	cp .vimrc ~/.$1
elif [ "$#" -eq 2 ]; then
	curl -fLo ~/.nvim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	cp .vimrc $2/.$1
else
	echo "Usage is [nvim/vim]  [optional :directory]"
fi

