#!/bin/bash

export TAG=5.0
export NETWORK=mongodb-dev
export TIMEZONE=Asia/Shanghai
export ROOTUSER=rootuser
export ROOTPASSWD=rootpasswd
export PORT=27017
export CONTAINER=mongodb-$PORT

export REPLICA_SET_NAME=devRepl

export DBUSER=dbuser
export DBPASSWD=dbpasswd
export DBDEV=dev

DEBUG=$1
if [ -z $DEBUG ]; then
    docker-compose -f mongodb.yaml up -d
else
    docker-compose -f mongodb.yaml up
fi
