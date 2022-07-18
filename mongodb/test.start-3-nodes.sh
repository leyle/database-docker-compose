#!/bin/bash

echo "start a mongodb replica set contains 3 nodes"

# fqdn: mgo0.replica.set
DOMAIN_SUFFIX=".dev.replicaset"
BASE_PORT=27017

WORK_DIR=$HOME/.config/replicaset
mkdir -p $WORK_DIR
cp -r ./replicaset $WORK_DIR/base
BASE_SCRIPTS_DIR=$WORK_DIR/base

# generate key file
KEY_FILE_NAME="dev.key"
KEY_FILE=$WORK_DIR/$KEY_FILE_NAME
echo "generate keyFile"
openssl rand -base64 756 > $KEY_FILE

echo "copy replicaset scripts to dst"
NUM=3
end_idx=$((NUM - 1))
for idx in $(seq 0 $end_idx);
do
    cd $WORK_DIR
    dst=$WORK_DIR/mgo${idx}
    cp -r  $BASE_SCRIPTS_DIR $dst
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
