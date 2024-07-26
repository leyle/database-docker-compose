#!/bin/bash

. ./env.sh

docker-compose -f docker-3nodes.yaml up -d 

docker run --rm -it --network host redis:$VERSION redis-cli --cluster create $IP:6379 $IP:6380 $IP:6381 --cluster-replicas 0 --cluster-yes
