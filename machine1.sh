#!/usr/bin/env bash

echo "RUN AS CLOUD-USER  Creating Machine1"

docker-machine --debug create --driver generic --generic-ip-address=127.0.0.1 --generic-ssh-key=/home/cloud-user/.ssh/id_rsa --generic-ssh-user=cloud-user --engine-opt="cluster-store=consul://192.168.25.91:8500" --engine-opt="cluster-advertise=eth0:2376" easjerrysolr1

echo "Verify that store and advertise is set..."
docker info|grep Cluster
