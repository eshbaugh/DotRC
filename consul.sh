#!/usr/bin/env bash


docker rm -f consul

#echo "Create keystore"
docker run -d -p 8400:8400 -p 8500:8500 -p 8600:53/udp -h node1 --name "consul"  progrium/consul -server –bootstrap -ui-dir /ui 





