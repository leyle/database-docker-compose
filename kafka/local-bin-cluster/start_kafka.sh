#!/bin/bash

# 1. stop all kafka process, simply kill java processes
# pgrep java | xargs kill -9
pgrep java && pgrep java | xargs kill -9

# 2. start 3 kafka processes

./bin/kafka-server-start.sh s1.properties > /tmp/kafka1.log 2>&1 &
./bin/kafka-server-start.sh s2.properties > /tmp/kafka2.log 2>&1 &
./bin/kafka-server-start.sh s3.properties > /tmp/kafka3.log 2>&1 &

echo "done"
sleep 5

tail -f /tmp/kafka1.log /tmp/kafka2.log /tmp/kafka3.log
