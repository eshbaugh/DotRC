#!/usr/bin/env bash

cp ../.vimrc ../.vimrc.bak
rm ../.vimrc
ln -s DotRC/.vimrc ../.vimrc

cp ../.bashrc ../.bashrc.bak
rm ../.bashrc 
ln -s DotRC/.bashrc ../.bashrc

# this does not work
#source ../.bashrc
