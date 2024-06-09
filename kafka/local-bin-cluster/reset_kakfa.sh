#!/bin/bash

# 1. stop all kafka process, simply kill java processes
# pgrep java | xargs kill -9
pgrep java && pgrep java | xargs kill -9

# 2. rm old kafka logs
LOG_PATH=/mytmp/kraft-combined-logs
rm -rf $LOG_PATH

# 3. regenerate kafka cluster id
KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)"

# 4. regenerate log path
./bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c s1.properties 
./bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c s2.properties 
./bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c s3.properties 

# 5. start 3 kafka processes

./bin/kafka-server-start.sh s1.properties > /tmp/kafka1.log 2>&1 &
./bin/kafka-server-start.sh s2.properties > /tmp/kafka2.log 2>&1 &
./bin/kafka-server-start.sh s3.properties > /tmp/kafka3.log 2>&1 &

echo "done"

tail -f /tmp/kafka1.log /tmp/kafka2.log /tmp/kafka3.log
