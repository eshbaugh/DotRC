#!/usr/bin/env bash

docker network create --driver overlay --subnet=10.7.9.0/24 solr-net

docker run --name zookeeper --net solr-net -d jplock/zookeeper
docker run --name solr1 --net solr-net -d solr:6.0 bash -c '/opt/solr/bin/solr start -c -f -z zookeeper'
docker run --name solr2 --net solr-net -d solr:6.0 bash -c '/opt/solr/bin/solr start -c -f -z zookeeper'
docker exec -i -t solr1 /opt/solr/bin/solr create_collection -c aaa -replicationFactor 2

