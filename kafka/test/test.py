#!/usr/bin/env python
#-*-coding:utf-8-*-
import socket
from confluent_kafka import Producer

conf = {
    "bootstrap.servers": "mq.org1.leyle.com:9093",
    "client.id": socket.gethostname(),
    }

topic = "dev-test"

def test():
    producer = Producer(conf)
    producer.produce(topic, key="key1", value="value1")
    producer.flush()

if __name__ == "__main__":
    test()
