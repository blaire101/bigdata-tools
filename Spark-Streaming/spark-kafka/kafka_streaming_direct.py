from pyspark import SparkContext
from pyspark import SparkConf
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils


def start():
    sconf = SparkConf()
    sconf.set('spark.cores.max', 2)
    sc = SparkContext(appName='KafkaDirectWordCount', conf=sconf)
    ssc = StreamingContext(sc, 2)

    brokers = "192.192.0.27:9092"
    topics = ['topic7']

    kafkaStreams_lines = KafkaUtils.createDirectStream(ssc, topics, kafkaParams={"metadata.broker.list": brokers})

    lines1 = kafkaStreams_lines.map(lambda x: x[1])  # 注意 取tuple下的第二个即为接收到的kafka流

    words = lines1.flatMap(lambda line: line.split(" "))

    pairs = words.map(lambda word: (word, 1))

    wordcounts = pairs.reduceByKey(lambda x, y: x + y)

    wordcounts.saveAsTextFiles("/var/lib/hadoop-hdfs/spark-libin/kafka")

    wordcounts.pprint()
    # 统计生成的随机数的分布情况
    ssc.start()  # Start the computation
    ssc.awaitTermination()  # Wait for the computation to terminate


if __name__ == '__main__':
    start()
