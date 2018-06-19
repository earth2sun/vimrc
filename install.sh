#!/bin/sh
Vundle=~/.vim/bundle/Vundle.vim
test -d $Vundle || git clone https://github.com/VundleVim/Vundle.vim.git $Vundle
line="source $(pwd)/vimrc"
grep -q "$line" ~/.vimrc || echo "$line" >> ~/.vimrc
vim +PluginInstall +qall
