#!/bin/bash

ENV_FILE=./env.sh

if [ ! -f "$ENV_FILE" ]; then
  echo "no env.sh, copy and modify sample.env to env.sh"
  exit 1
fi

. $ENV_FILE

debug=$1

if [ -z "$debug" ]; then
  docker-compose -f kafka.yaml up -d
else
  docker-compose -f kafka.yaml up
fi

echo "done"
