#!/usr/bin/env bash

# Solr1: publicIP: 162.79.27.42    PrivateIP: 192.168.25.90
# Solr1: publicIP: 162.79.27.44    PrivateIP: 192.168.25.91

if [ $HOSTNAME = "easjerrysolr.novalocal" ]; then
  # This is the host IP for the other server
  SOLR1=solr11
  SOLR2=solr12

elif [ $HOSTNAME = "easjerrysolr2.novalocal" ]; then
  # This is the host IP for the other server
  SOLR1=solr21
  SOLR2=solr22

else
  echo "Unsupported host:" $HOSTNAME
  exit
fi

# Use the same Zookeeper server for both
IP1=192.168.25.90
IP2=192.168.25.91
ZK_PORT=2181

# we need zookeeper running on both hosts or --link zookeeper:ZK failes
echo "running ZK"
docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper

IPP1=$IP1':'$ZK_PORT
IPP2=$IP2':'$ZK_PORT

# Running this on both hosts... ERROR: Cannot connect to cluster at 192.168.25.90:2181,192.168.25.91:2181: cluster not found/not ready when doing a zoopop.sh
# docker run --name $SOLR1 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z '$IPP1','$IPP2' -noprompt'

if [ $HOSTNAME = "easjerrysolr.novalocal" ]; then
  docker run --name $SOLR1 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'
else
  # second host
  docker run --name $SOLR1 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z '$IPP1' -noprompt'
fi


docker ps -a

echo "done"
