#!/usr/bin/env bash

# web 3  192.168.25.41
# web 4  192.168.25.42


#docker network create --driver overlay --subnet=10.7.9.0/24 solr-net

# host:container
docker run --name zookeeper -p 2182:2181 -p 9:999 -d jplock/zookeeper
sleep 20
docker run --name solr1 -d solr bash -c '/opt/solr/bin/solr start -c -f -z 192.168.25.42:2182'
docker run --name solr2 -d solr bash -c '/opt/solr/bin/solr start -c -f -z 192.168.25.42:2182'
sleep 20
docker exec solr1 /opt/solr/bin/solr status


#docker exec -i -t solr1 /opt/solr/bin/solr create_collection -c aaa -replicationFactor 2


