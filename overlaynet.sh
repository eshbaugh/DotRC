#!/usr/bin/env bash

echo "Create overlay network"
docker network create --driver overlay --subnet=10.7.9.0/24 my-net






