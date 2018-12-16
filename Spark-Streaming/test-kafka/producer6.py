# producer
import time
from kafka import KafkaProducer

producer = KafkaProducer(bootstrap_servers=['192.192.0.27:9092'])  #此处ip可以是多个['0.0.0.1:9092','0.0.0.2:9092','0.0.0.3:9092' ]

for i in range(200):
    ts =int(time.time()*1000)
    msg = "producer6 + msg%d" % i
    print(msg)
    # producer.send(topic="topic6")
    producer.send(topic="topic6", value=None, key=None, partition=None, timestamp_ms=None)
    time.sleep(1)
producer.close()