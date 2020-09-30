// Copyright 2016 x Corp.
// Author: bean.values@gmail.com

name := "WordCount"

organization := "com.x"

version := "1.0"

scalaVersion := "2.11.5"

libraryDependencies += "org.apache.spark" % "spark-core_2.10" % "1.5.2"
// https://mvnrepository.com/artifact/org.apache.spark/spark-mllib-local_2.11
//libraryDependencies += "org.apache.spark" % "spark-mllib-local_2.11" % "2.0.0"


resolvers += "Akka Repository" at "http://repo.akka.io/releases"

