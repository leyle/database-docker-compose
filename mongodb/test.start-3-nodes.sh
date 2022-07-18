#!/bin/bash

echo "start a mongodb replica set contains 3 nodes"

# fqdn: mgo0.replica.set
DOMAIN_SUFFIX=".dev.pymom.com"
BASE_PORT=27017

BASE=$HOME/.config/replicaset
mkdir -p $BASE

# generate key file
KEY_FILE_NAME="dev.key"
KEY_FILE=$BASE/$KEY_FILE_NAME
echo "generate keyFile"
openssl rand -base64 756 > $KEY_FILE

echo "copy replicaset scripts to dst"
NUM=3
end_idx=$((NUM - 1))
for idx in $(seq 0 $end_idx);
do
    dst=$BASE/mgo${idx}
    cp -r ./replicaset $dst
    cp $KEY_FILE $dst/keyfile/$KEY_FILE_NAME

    # set env.sh
    container=mgo${idx}${DOMAIN_SUFFIX}
    port=$((BASE_PORT + idx))

    echo " " >> $dst/env.sh
    echo "export CONTAINER=$container" >> $dst/env.sh
    echo "export PORT=$port" >> $dst/env.sh

    # start container
    cd $dst
    ./start.sh
done

# try to use rs.initiate() function to create replica set
echo "use rs.initiate() to create replica set"
