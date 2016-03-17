#!/usr/bin/env bash


docker rm -f consul

#echo "Create keystore"
docker run -d   -p "8500:8500"   -h  "consul" --name "consul"  progrium/consul -server -bootstrap

