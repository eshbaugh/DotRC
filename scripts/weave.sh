#!/usr/bin/env bash


sudo curl -L git.io/weave -o /usr/local/bin/weave
cd /usr/local/bin
chmod +x weave
./weave launch
eval $(./weave env)

