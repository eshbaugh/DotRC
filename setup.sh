#!/usr/bin/env bash

cp ../.vimrc ../.vimrc.bak
rm ../.vimrc
ln -s linux/.vimrc ../.vimrc

cp ../.bashrc ../.bashrc.bak
rm ../.bashrc 
ln -s linux/.bashrc ../.bashrc

# this does not work
#source ../.bashrc
