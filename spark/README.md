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
 - 2014-02 : Apache 顶级项目  
 - 2014-05 : Spark 1.0.0 发布

## 2. Spark 之于 Hadoop
 
 Spark 是 MapReduce 的替代方案, 且兼容 HDFS、Hive 等分布式存储层。

 Spark 相比 Hadoop MapReduce 的优势如下 :

 1. 中间结果输出
 2. 数据格式和内存布局
 3. 执行策略  
 4. 任务调度的开销
    
> Spark用事件驱动类库AKKA来启动任务, 通过线程池复用线程避免进线程启动切换开销

## 3. Spark 能带来什么 ?
 
 1. 打造全栈多计算范式的高效数据流水线
 2. 轻量级快速处理, 并支持 Scala、Python、Java
 3. 与 HDFS 等 存储层 兼容

## 4. Spark 安装与部署

Spark 主要使用 HDFS 充当持久化层，所以完整的安装 Spark 需要先安装 Hadoop. 
Spark 是计算框架, 它主要使用 HDFS 充当持久化层。

**Linux 集群安装 Spark**

1. 安装 JDK
2. 安装 Scala
3. 配置 SSH 免密码登陆 (可选)
4. 安装 Hadoop
5. 安装 Spark
6. 启动 Spark 集群
