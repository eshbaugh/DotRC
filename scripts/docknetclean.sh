#!/usr/bin/env bash
echo "Removing test networks"

docker network rm docker_gwbridge
docker network rm farmtoschoolcensus-fns-usda-net
docker network ls

echo "done"
