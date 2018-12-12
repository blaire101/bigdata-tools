
# producer
import time
from kafka import KafkaProducer
 
producer = KafkaProducer(bootstrap_servers=['localhost:9092'])  #此处ip可以是多个['0.0.0.1:9092','0.0.0.2:9092','0.0.0.3:9092' ]
 
for i in range(300):
    ts =int(time.time()*1000)
    msg = "produce yao + msg%d" % i
    print(msg)
    producer.send("test", msg.encode('utf-8'))
    time.sleep(1)
producer.close()

