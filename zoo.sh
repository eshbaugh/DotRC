#!/usr/bin/env bash

HOST1_IP_PUB=162.79.27.42
HOST1_IP_PRI=192.168.25.90
HOST2_IP_PUB=162.79.27.44   
HOST2_IP_PRI=192.168.25.91
ZK_PORT=2181

docker ps -a

# to run a basic solr container detached/port/sudotty
# docker run --name my_solr -d -p 8983:8983 -t solr

echo "Ignore no such ID errors from  zookeeper and solarxx the first time this script is run on a new host"

if [ $HOSTNAME = "easjerrysolr.novalocal" ]; then
  docker stop zookeeper
  docker rm zookeeper
  docker stop solr11
  docker stop solr12
  docker rm solr11
  docker rm solr12

  echo "running ZK"
  docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper

  echo "running solr11"
  docker run --name solr11 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'
  echo "running solr12"
  docker run --name solr12 --link zookeeper:ZK -d -p 8984:8983 solr bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'

  echo "creating collection co1 with two shards on solr11 and 12"
  docker exec -it solr11 /opt/solr/bin/solr create_collection  -c co1 -shards 2 -p 8983

  echo "creating collection getting started"
  docker exec -it --user=solr solr11 bin/solr create_collection -c eg1

  echo "populating getting started with computer manufactures"
  docker exec -it --user=solr solr11 bin/post -c eg1 example/exampledocs/manufacturers.xml

elif [ $HOSTNAME = "easjerrysolr2.novalocal" ]; then

  
  docker stop zookeeper
  docker rm zookeeper
  docker stop solr21
  docker rm solr21
  docker stop solr22
  docker rm solr22

  #echo "running ZK"
  docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper

#  -z easjerrysolr.novalocal:2181 when visiting port 8983 in a web browser get a error 500 page 
#  -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'

  docker run --name solr21 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z  '$HOST1_IP_PRI':'$ZK_PORT
  docker run --name solr22 --link zookeeper:ZK -d -p 8984:8983 solr bash -c '/opt/solr/bin/solr start -f -z  '$HOST1_IP_PRI':'$ZK_PORT

#  echo "creating collection co2 with two shards on solr21"
#  docker exec -it solr21 /opt/solr/bin/solr create_collection  -c co2 -shards 2 -p 8983

#  echo "creating collection getting started"
#  docker exec -it --user=solr solr21 bin/solr create_collection -c eg2

#  echo "populating getting started with computer manufactures"
#  docker exec -it --user=solr solr21 bin/post -c co2 example/exampledocs/manufacturers.xml

else
  echo "Unsupported host:" $HOSTNAME
  exit
fi

docker ps -a

if true ; then
  echo "done"
fi
