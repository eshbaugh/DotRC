#!/usr/bin/env bash

# this is an example from https://docs.docker.com/engine/userguide/networking/get-started-overlay/

docker rm -f keystore

# Need to install docker maachine first.
# curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine && chmod +x /usr/local/bin/docker-machine

docker create -d virtualbox mh-keystore

docker $(docker-machine config mh-keystore) run -d -p "8500:8500" -h "consul" progrium/consul -server -bootstrap



