#!/usr/bin/env bash

cp ../.vimrc ../.vimrc.bak
rm ../.vimrc
ln -s DotRC/.vimrc ../.vimrc

cp ../.bashrc ../.bashrc.bak
rm ../.bashrc 
ln -s DotRC/.bashrc ../.bashrc

cp ../.gitconfig ../.gitconfig.bak
rm ../.gitconfig 
ln -s DotRC/.gitconfig ../.gitconfig

# this does not work
#source ../.bashrc
