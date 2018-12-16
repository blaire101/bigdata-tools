import sys
from pyspark import SparkContext
from pyspark.streaming import StreamingContext

# 创建本地的SparkContext对象，包含3个执行线程
sc = SparkContext("local[3]", "streamwordcount")

# 创建本地的StreamingContext对象，处理的时间片间隔时间，设置为2s
ssc = StreamingContext(sc, 2)

lines = ssc.socketTextStream("localhost", 9999)

# 使用flatMap和Split对2秒内收到的字符串进行分割
words = lines.flatMap(lambda line: line.split(" "))

pairs = words.map(lambda word: (word, 1))
wordCounts = pairs.reduceByKey(lambda x, y: x + y)

wordCounts.pprint()

ssc.start()
# 启动Spark Streaming应用

ssc.awaitTermination()

