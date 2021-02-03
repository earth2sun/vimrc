#!/bin/sh

cur_dir=$(dirname $(readlink -f $0))
vimrc=${cur_dir}/vimrc
invoke_line="source $vimrc"
Vundle=~/.vim/bundle/Vundle.vim

test -d $Vundle || git clone https://github.com/VundleVim/Vundle.vim.git $Vundle
test -e ~/.vimrc || touch ~/.vimrc
grep -q "$invoke_line" ~/.vimrc && exit 0
echo "$invoke_line" >> ~/.vimrc
vim +PluginInstall +qall
