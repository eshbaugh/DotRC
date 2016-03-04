#!/usr/bin/env bash

docker stop solr1
docker rm solr1
docker stop solr2
docker rm solr2
docker stop zookeeper
docker rm zookeeper

# 2181 client, 2888 pier, 3888 leader election
docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888  jplock/zookeeper

docker run --name solr1 -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z 192.168.25.90:2181'

docker exec -i -t solr1 /opt/solr/bin/solr create_collection  -c collection1 -shards 2 -p 8983
docker exec -it --user=solr solr1 bin/solr create_collection -c gettingstarted

docker ps -a
