#!/usr/bin/env python
#-*-coding:utf-8-*-
import socket
import time
from confluent_kafka import Producer

conf = {
    'bootstrap.servers': 'kafka.org0.vm5.pymom.com:9092,kafka.org1.vm6.pymom.com:9092,kafka.org2.vm7.pymom.com:9092',
    "client.id": socket.gethostname(),
    }

topic = "dev-test"

def test():
    producer = Producer(conf)
    producer.produce(topic, key=str(time.time()), value=str(time.time()))
    producer.flush()

if __name__ == "__main__":
    test()
