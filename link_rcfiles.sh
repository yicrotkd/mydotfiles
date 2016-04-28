#!/bin/bash

files=("_bashrc" "_eslintrc" "_psqlrc" "_pylintrc" "_screenrc" "_vimrc" "_zshrc")

cdir=`pwd`

for file in ${files[@]}; do
	dotfile=`echo $file | tr "_" "."`
	ln -s $cdir/$file $HOME/$dotfile
done
