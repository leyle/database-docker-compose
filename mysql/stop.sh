#!/bin/bash

export TAG=8.0
export NETWORK=mysql-dev
export TIMEZONE=Asia/Shanghai
export PASSWORD=abc123
export PORT=3306
export CONTAINER=mysql-$PORT

docker-compose -f mysql.yaml down
