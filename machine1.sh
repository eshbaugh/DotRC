#!/usr/bin/env bash

echo "Creating dockermachine solr1 connecting to Slor2's keystore"

docker-machine --debug create --driver generic --generic-ip-address=127.0.0.1 --generic-ssh-key=/home/cloud-user/.ssh/id_rsa --generic-ssh-user=cloud-user --engine-opt="cluster-store=consul://192.168.25.91:8500" --engine-opt="cluster-advertise=eth0:2376" easjerrysolr1




