#!/usr/bin/env bash

docker stop solr1
docker stop solr2
docker stop zookeeper
docker rm solr1
docker rm solr2
docker rm zookeeper

docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper

docker run --name solr1 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'

docker run --name solr2 --link zookeeper:ZK -d -p 8984:8983 solr bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'

docker exec -i -t solr1 /opt/solr/bin/solr create_collection  -c collection1 -shards 2 -p 8983

docker exec -it --user=solr solr1 bin/solr create_collection -c gettingstarted

docker exec -it --user=solr solr1 bin/post -c gettingstarted example/exampledocs/manufacturers.xml

docker ps -a
