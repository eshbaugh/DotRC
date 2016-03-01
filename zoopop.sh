#!/usr/bin/env bash


if [ $HOSTNAME = "easjerrysolr.novalocal" ]; then
  SOLR1=solr11
elif [ $HOSTNAME = "easjerrysolr2.novalocal" ]; then
  SOLR1=solr21
fi


# create sample data
echo "creating collection with two shards"

COLL=$SOLR1'col'
docker exec -it $SOLR1 /opt/solr/bin/solr create_collection -c $COLL -shards 2 -p 8983


echo "creating EG data"
EG=$SOLR1'eg'
docker exec -it --user=solr $SOLR1  bin/solr create_collection -c $EG
docker exec -it --user=solr $SOLR1  bin/post -c $EG example/exampledocs/manufacturers.xml

echo "done"
