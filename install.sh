#!/bin/sh

init_vimrc() {
    Vundle=~/.vim/bundle/Vundle.vim
    test -d $Vundle || git clone https://github.com/VundleVim/Vundle.vim.git $Vundle
    [ -e $vimrc ] && grep -q "$line" ~/.vimrc && exit 0
    echo "$line" >> ~/.vimrc
    vim +PluginInstall +qall
}

init_vimrc
