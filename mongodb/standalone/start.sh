#!/bin/bash

export TAG=4.4
export NETWORK=mongodb-dev
export TIMEZONE=Asia/Shanghai
export ROOTUSER=rootuser
export ROOTPASSWD=rootpasswd
export PORT=27017
export CONTAINER=mongodb-$PORT

export DBUSER=dbuser
export DBPASSWD=dbpasswd
export DBDEV=dev

DEBUG=$1
if [ -z $DEBUG ]; then
    docker-compose -f mongodb.yaml up -d
else
    docker-compose -f mongodb.yaml up
fi
