#!/usr/bin/env bash

cp ~/.vimrc ~/.vimrc.bak
rm ~/.vimrc
ln -s DotRC/.vimrc ~/.vimrc

cp ~/.bashrc ~/.bashrc.bak
rm ~/.bashrc 
ln -s DotRC/.bashrc ~/.bashrc

cp ~/.gitconfig ~/.gitconfig.bak
rm ~/.gitconfig 
ln -s ~/private/.gitconfig ~/.gitconfig

cp ~/.gitignore ~/.gitignore.bak
rm ~/.gitignore
ln -s DotRC/.gitignore ~/.gitignore
git config --global core.excludesfile ~/.gitignore

# this does not work the data is sourced into the bash script not ssh shell
#source ../.bashrc
