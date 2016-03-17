#!/usr/bin/env bash

echo "Create overlay network"
docker network create --driver overlay --subnet=19.7.9.0/24 solr-net






