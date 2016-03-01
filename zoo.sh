#!/usr/bin/env bash

if [ $HOSTNAME = "easjerrysolr.novalocal" ]; then
  # This is the host IP for the other server
#  HOST_IP_PUB=162.79.27.44   
#  HOST_IP_PRI=192.168.25.91
  SOLR1=solr11
  SOLR2=solr12

elif [ $HOSTNAME = "easjerrysolr2.novalocal" ]; then
  # This is the host IP for the other server
#  HOST_IP_PUB=162.79.27.42
#  HOST_IP_PRI=192.168.25.90
  SOLR1=solr21
  SOLR2=solr22

else
  echo "Unsupported host:" $HOSTNAME
  exit
fi

# Use the same Zookeeper server for both
HOST_IP_PUB=162.79.27.42
HOST_IP_PRI=192.168.25.90
ZK_PORT=2181

docker ps -a

echo "running ZK"
docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper

IPP=$HOST_IP_PRI':'$ZK_PORT

echo "running " $SOLR1 
docker run --name $SOLR1 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z '$IPP

echo "running " $SOLR2 
docker run --name $SOLR2 --link zookeeper:ZK -d -p 8984:8983 solr bash -c '/opt/solr/bin/solr start -f -z '$IPP

# create sample data
if [ $HOSTNAME = "easjerrysolr2.novalocal" ]; then
  echo "creating collection with two shards"
  COLL=$SOLR1'col'
  docker exec -it $SOLR1 /opt/solr/bin/solr create_collection -c $COLL -shards 2 -p 8983

  echo "populating getting started with computer manufactures"
  docker exec -it --user=solr $SOLR1 bin/post -c $COLL example/exampledocs/manufacturers.xml
fi

docker ps -a

echo "done"
