# Spark

介绍 Spark 的历史，介绍 Spark 的安装与部署，介绍 Spark 的代码架构 等

<!--more-->

Spark 发源于 美国加州大学伯克利分校 AMPLap 大数据分析平台  
Spark 立足于内存计算、从多迭代批量处理出发  
Spark 兼顾数据仓库、流处理、图计算 等多种计算范式，大数据系统领域全栈计算平台  

<a href="http://spark.apache.org">spark.apache.org</a> 

> University of California, Berkeley 

## 1. Spark 的历史与发展

 - 2009 年 : Spark 诞生于 AMPLab  
 - 2014 年 : Spark 1.0.0 发布
 - 2019 年 : Spark 3.0.0 发布

## 2. Spark 之于 Hadoop
 
 Spark 是 MapReduce 的替代方案, 且兼容 HDFS、Hive 等分布式存储层。

 Spark 相比 Hadoop MapReduce 的优势如下 :

 1. 中间结果输出
 2. 数据格式和内存布局
 3. 执行策略  
 4. 任务调度的开销
    
> Spark用事件驱动类库AKKA来启动任务, 通过线程池复用线程避免进线程启动切换开销

## 3. Spark 能带来什么 ?
 
spark-3.0.0-bin-hadoop3.2

## 4. pyspark test

```bash
logFile="file:////Users/blair/ghome/github/spark3.0/pyspark/README.md"
logData=sc.textFile(logFile).cache()
numAs=logData.filter(lambda s:'a' in s).count()
numbs=logData.filter(lambda s:'b' in s).count()
numAs
numBs
```
