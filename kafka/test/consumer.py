#!/usr/bin/env python
#-*-coding:utf-8-*-
from confluent_kafka import Consumer

c = Consumer({
    'bootstrap.servers': 'kafka.org0.vm5.pymom.com:9092,kafka.org1.vm6.pymom.com:9092,kafka.org2.vm7.pymom.com:9092',
    'group.id': 'dev-test',
    'auto.offset.reset': 'earliest'
})

c.subscribe(['dev-test'])

while True:
    msg = c.poll(1.0)

    if msg is None:
        continue
    if msg.error():
        print("Consumer error: {}".format(msg.error()))
        continue

    print('Received message: key:{}, value:{}'.format(msg.key().decode('utf-8'), msg.value().decode('utf-8')))

