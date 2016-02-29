#!/usr/bin/env bash

HOST1=162.79.27.42
HOST2=162.79.27.44
PORT=2181
IP_PORT=$HOST1:$PORT

docker ps -a

docker stop zookeeper
docker rm zookeeper

if [ $HOSTNAME = "easjerrysolr.novalocal" ]; then

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

  docker stop solr21
  docker rm solr21
  docker stop solr22
  docker rm solr22

  echo "running ZK"
  docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper

  docker run --name solr21 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z 172.17.0.3:2181'

  docker run --name solr22 --link zookeeper:ZK -d -p 8984:8983 solr bash -c '/opt/solr/bin/solr start -f -z 172.17.0.3:2181'

  echo "creating collection co2 with two shards on solr21 and 22"
  docker exec -it solr21 /opt/solr/bin/solr create_collection  -c co2 -shards 2 -p 8983

  echo "creating collection getting started"
  docker exec -it --user=solr solr21 bin/solr create_collection -c eg2

  echo "populating getting started with computer manufactures"
  docker exec -it --user=solr solr21 bin/post -c eg2 example/exampledocs/manufacturers.xml

else
  echo "Unsupported host:" $HOSTNAME
  exit
fi

docker ps -a

if true ; then
  echo "done"
fi
