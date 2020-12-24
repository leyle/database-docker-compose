#!/bin/bash

export TAG=4.4
export NETWORK=mongodb-dev
export TIMEZONE=Asia/Shanghai
export ROOTUSER=rootuser
export ROOTPASSWD=rootpasswd
export PORT=27017
export CONTAINER=mongodb-$PORT

docker-compose -f mongodb.yaml down
