#!/usr/bin/env bash

#docker run --net=network

#Create keystore
docker run -d     -p "8500:8500"     -h "consul"     progrium/consul -server –bootstrap 

# eval "$(docker-machine env mh-keystore)" 
echo "Create overlay network"
docker network create --driver overlay --subnet=10.7.9.0/24 my-net






