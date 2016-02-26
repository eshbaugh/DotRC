#!/usr/bin/env bash

HOST1=162.79.27.42
HOST2=162.79.27.44
PORT=2181

docker ps -a
docker stop solr1
docker stop solr2
docker stop zookeeper
docker rm solr1
docker rm solr2
docker rm zookeeper

if [ $HOSTNAME = "easjerrysolr.novalocal" ]; then
  IP_PORT=$HOST1:$PORT

  docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper

  docker run --name solr11 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'
  docker run --name solr12 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'

  docker exec -i -t solr11 /opt/solr/bin/solr create_collection  -c collection1 -shards 2 -p 8983
  docker exec -it --user=solr solr11 bin/solr create_collection -c gettingstarted
  docker exec -it --user=solr solr11 bin/post -c gettingstarted example/exampledocs/manufacturers.xml

elif [ $HOSTNAME = "easjerrysolr2.novalocal" ]; then
  IP_PORT=$HOST2:$PORT

  docker run --name solr21 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z '$IP_PORT 


else
  echo "Unsupported host:" $HOSTNAME
  exit
fi



docker ps -a

if true ; then
  echo "done"
fi
