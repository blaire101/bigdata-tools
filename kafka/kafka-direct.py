from pyspark import SparkContext
from pyspark import SparkConf
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils

import os
import sys
import logging


def start():
    sconf = SparkConf()
    sconf.set('spark.cores.max', 2)
    sc = SparkContext(appName='KafkaDirectWordCount', conf=sconf)
    ssc = StreamingContext(sc, 2)

    brokers = "localhost:9092"
    topics = ['test']

    kafkaStreams_lines = KafkaUtils.createDirectStream(ssc, topics, kafkaParams={"metadata.broker.list": brokers})

    lines1 = kafkaStreams_lines.map(lambda x: x[1])  # 注意 取tuple下的第二个即为接收到的kafka流

    words = lines1.flatMap(lambda line: line.split(" "))

    pairs = words.map(lambda word: (word, 1))

    wordcounts = pairs.reduceByKey(lambda x, y: x + y)

    print(wordcounts)

    kafkaStreams_lines.transform(storeOffsetRanges).foreachRDD(printOffsetRanges)

    wordcounts.pprint()
    # 统计生成的随机数的分布情况
    ssc.start()  # Start the computation
    ssc.awaitTermination()  # Wait for the computation to terminate

offsetRanges = []

def storeOffsetRanges(rdd):
    global offsetRanges
    offsetRanges = rdd.offsetRanges()
    return rdd
def printOffsetRanges(rdd):
    for o in offsetRanges:
        print ("%s %s %s %s %s" % (o.topic, o.partition, o.fromOffset, o.untilOffset,o.untilOffset-o.fromOffset))

if __name__ == '__main__':

    print("hello, start..")

    program = os.path.basename(sys.argv[0])
    logger = logging.getLogger(program)
    logging.basicConfig(format='%(asctime)s: %(levelname)s: %(message)s')
    logging.root.setLevel(level=logging.WARN)
    logger.warning("running %s" % ' '.join(sys.argv))

    start()

