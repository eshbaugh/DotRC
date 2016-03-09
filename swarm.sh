#!/usr/bin/env bash

# http://www.container42.com/2015/10/30/docker-networking-reborn/

#echo "Creating keystore VirtualBox"
# on linux use: docker-machine create --driver generic --generic-ip-address=203.0.113.81 mh-keystore
#docker-machine create -d virtualbox mh-keystore 

#echo "eval keystore"
#eval "$(docker-machine env mh-keystore)" 

echo "Docker run consul"
docker rm -f consul
docker run -d -p "8500:8500" -h "consul" --name "consul"  progrium/consul -server –bootstrap 

#echo "Create swarm master"
#docker-machine create -d virtualbox --swarm --swarm-master --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" --engine-opt="cluster-advertise=eth1:2376" mhs-demo0 
#
#echo "Create swarm discovery"
#docker-machine create -d virtualbox --swarm --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" --engine-opt="cluster-advertise=eth1:2376" mhs-demo1
#
#echo "eval swarm demo0"
#eval $(docker-machine env --swarm mhs-demo0) 

#echo "Docker Info"
#docker info

#echo "Create overlay network"
#docker network create --driver overlay --subnet=10.7.9.0/24 my-net

# Final Error: Error response from daemon: No healthy node available in the cluster



