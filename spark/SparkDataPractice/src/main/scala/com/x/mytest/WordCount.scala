package com.x.mytest

/* WordCount.scala */

import org.apache.spark.{SparkConf, SparkContext}

/**
 * Author : clb@x.com
 * Date : 2016-03-23
 */

object WordCount {
  def main(args: Array[String]) {
    if (args.length < 1) {
      System.err.println("Usage: <file>")
      System.exit(1)
    }

    val conf = new SparkConf()
    val sc = new SparkContext(conf)
    val line = sc.textFile(args(0))

    line.flatMap(_.split(" ")).map((_, 1)).reduceByKey(_ + _).collect().foreach(println)

    sc.stop()
  }
}