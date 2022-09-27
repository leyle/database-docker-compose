#!/bin/bash

export TAG=7.0
export NETWORK=redis-dev
export TIMEZONE=Asia/Shanghai
export PASSWORD=abc123
export PORT=6379
export CONTAINER=redis-server-$PORT

docker-compose -f redis.yaml up -d
