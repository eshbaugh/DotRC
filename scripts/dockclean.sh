#!/usr/bin/env bash
echo "Removing test container"
docker rm -f test1
docker rm -f test2
docker ps

echo "done"
