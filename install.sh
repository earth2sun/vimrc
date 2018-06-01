#!/bin/sh

vimrc=$(readlink -f vimrc)
echo "source $vimrc" >> ~/.vimrc
