from pyspark import SparkContext
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils

sc = SparkContext("local[2]", "KafkaWordCount")

ssc = StreamingContext(sc, 2)
zookeeper = "192.192.0.25:2181,192.192.0.26:2181,192.192.0.27:2181"

topics ={"topic6": 0, "topic6": 1, "topic6": 2}  # 要列举出分区
groupid = "blair-consumer-group"

lines = KafkaUtils.createStream(ssc, zookeeper, groupid, topics)
lines1 = lines.map(lambda x: x[1])  # 注意 取tuple下的第二个即为接收到的kafka流

words = lines1.flatMap(lambda line: line.split(" "))

pairs = words.map(lambda word: (word, 1))

wordcounts = pairs.reduceByKey(lambda x, y: x + y)

wordcounts.saveAsTextFiles("/var/lib/hadoop-hdfs/spark-libin/kafka")

wordcounts.pprint()

ssc.start()
ssc.awaitTermination()
