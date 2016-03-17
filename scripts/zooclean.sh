#!/usr/bin/env bash


if [ $HOSTNAME = "easjerrysolr.novalocal" ]; then
  SOLR1=solr11
  SOLR2=solr12

elif [ $HOSTNAME = "easjerrysolr2.novalocal" ]; then
  # This is the host IP for the other server
  SOLR1=solr21
  SOLR1=solr11
  SOLR2=solr22

else
  echo "Unsupported host:" $HOSTNAME
  exit
fi

echo "Ignore <no such ID> errors this script is run on a new host"
docker stop zookeeper
docker rm zookeeper
docker stop $SOLR1
docker stop $SOLR2
docker rm $SOLR1
docker rm $SOLR2

docker ps -a

echo "done"
