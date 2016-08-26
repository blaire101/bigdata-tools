
# SBT Spark WordCount

### Build

工程使用SBT作为构建工具。

##### 编译

`sbt/sbt compile`，会编译包括java和scala的源码。

##### 测试

`sbt/sbt test`，会执行src/test/scala下的单元测试。

##### 打包

`sbt/sbt package`，会对每一个子项目生成单独的jar包。

##### 运行, 可提交到 Spark 上运行

```scala
$SPARK_HOME/bin/spark-submit \
  --name WordCount \
  --class WordCount \
  target/scala-2.11/wordcount_2.11-1.0.jar src/data/word.txt
```


