// Copyright 2016 x Corp.
// Author: bean.values@gmail.com

name := "HelloWorld"

organization := "com.x"

version := "1.0"

scalaVersion := "2.11.5"

libraryDependencies += "org.apache.spark" % "spark-core_2.10" % "1.5.2"

// not use fastjson
libraryDependencies += "com.alibaba" % "fastjson" % "1.2.8"

resolvers += "Akka Repository" at "http://repo.akka.io/releases"

