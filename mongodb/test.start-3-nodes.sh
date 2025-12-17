#!/bin/bash
#

CUR_DIR=$PWD

echo "start a mongodb replica set contains 3 nodes"

# fqdn: mgo0.replica.set
DOMAIN_SUFFIX=".dev.test"
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
# echo "use rs.initiate() to create replica set"
echo "sleep 5s to setup cluster"
sleep 5
cd $CUR_DIR
docker exec -it mgo0.dev.test mongosh --eval "$(cat setup.replicaset.js)"

# create more users/databases
# This connects to the Replica Set, not just the single container.
# Mongosh will auto-discover the Primary.
docker exec -i mgo0.dev.test mongosh \
  "mongodb://mgo0.dev.test:27017,mgo1.dev.test:27018,mgo2.dev.test:27019/admin?replicaSet=devRepl" \
  --quiet --eval "$(cat setup.users.js)"
