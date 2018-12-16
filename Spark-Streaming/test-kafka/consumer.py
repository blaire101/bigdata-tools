# consumer.py

from collections import Iterable
from kafka import KafkaConsumer

consumer = KafkaConsumer('topic5',  bootstrap_servers=['192.192.0.27:9092'])
print(consumer)
print(type(consumer))
print(consumer.topics())

print(isinstance(consumer,Iterable))

for message in consumer:
    print("hello consumer")
    print("%s:%d:%d: key=%s value=%s" % (message.topic, message.partition,
                                          message.offset, message.key, message.value))