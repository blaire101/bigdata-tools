package com.x.dataPractice

import org.apache.spark.SparkContext
import org.apache.spark.mllib.regression.LinearRegressionWithSGD
import org.apache.spark.mllib.classification.SVMWithSGD
import org.apache.spark.mllib.linalg.Vectors
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.mllib.tree.DecisionTree
import org.apache.spark.mllib.tree.configuration.Algo
import org.apache.spark.mllib.tree.impurity.Entropy
import org.apache.spark.mllib.feature.ChiSqSelector
import org.apache.spark.mllib.feature.Normalizer
import org.apache.spark.mllib.tree.RandomForest
import org.apache.spark.mllib.tree.configuration.Strategy
import collection.mutable.ArrayBuffer

object Rings {
  def main (args: Array[String]): Unit = {
        val sc = new SparkContext("local[2]", "Rings");
        val rawData=sc.textFile("/home/deploy/pkbigdata/Rings/traindata.csv").filter(line=> !line.contains("Sex"))
        
//        val records=rawData.map(line=>line.split(",")).map(fields=> (fields(0),fields.map(_.replace("\"",""))))
        val records=rawData.map(line=>line.split(","))

        val sexMap = Map("F"->0,"I"->1,"M"->2)
        val data=records.map{ r=>
           val mapped = r.map(_.replaceAll(r(0), sexMap(r(0)).toString()))
           val label=r(r.size-1).toInt
           val features=mapped.slice(0, r.size-1).map(d=> d.toDouble)
           LabeledPoint(label,Vectors.dense(features))
        }
        
        data.cache()
        
        val numData=data.count()
        val numIterations=10
        val maxTreeDepth=30
        val maxBins=320
        val step=0.1
        val intercept=0
        
//        val lrModel=LinearRegressionWithSGD.train(data, numIterations)
////      
//        val lrTotalCorrect=data.map{ point =>
//          if(lrModel.predict(point.features).round == point.label) 1 else 0
//        }.sum
//////        
//        val lrAccuracy=lrTotalCorrect/numData
//        println("lrAccuracy="+lrAccuracy)
        val splits = data.randomSplit(Array(0.7, 0.3))
        val (trainingData, testData) = (splits(0), splits(1))

        val categoricalFeaturesInfo = Map(0->3)
        val impurity = "variance"
        
//        val dtModel=DecisionTree.trainRegressor(trainingData, categoricalFeaturesInfo,impurity , maxTreeDepth, maxBins)
//        val true_vs_predicted_dt=data.map(point => (point.label.toInt,dtModel.predict(point.features).toInt))
//        true_vs_predicted_dt.collect().foreach(println)
//        val dtModel=DecisionTree.train(data, Algo.Classification, Entropy, maxTreeDepth)
        
//        val dtTotalCorrect=trainingData.map{ point=>
//          val rings= dtModel.predict(point.features).toInt
//          if(rings == point.label ) 1 else 0
//        }.sum()
//
//        val dtAccuracy = dtTotalCorrect/trainingData.count()
//        println("dtAccuracy="+dtAccuracy)
        
//        val testCorrect=testData.map{ testpoint=>
//          val testrings= dtModel.predict(testpoint.features).round
//          if(testrings == testpoint.label ) 1 else 0
//        }.sum()
////
//        val testAccuracy = testCorrect/testData.count
//        println("testAccuracy="+testAccuracy)
        

//        
//        // Train a RandomForest model.
//        val treeStrategy = Strategy.defaultStrategy("Classification")
        val treeStrategy = Strategy.defaultStrategy(Algo.Regression)
        val numTrees = 300 // Use more in practice.
        val featureSubsetStrategy = "auto" // Let the algorithm choose.
        val dtFmodel = RandomForest.trainRegressor(trainingData, categoricalFeaturesInfo, numTrees, featureSubsetStrategy, impurity, maxTreeDepth, maxBins)
////        
        val dtFTotalCorrect=trainingData.map{ point=>
          val rings= dtFmodel.predict(point.features).round
          if(rings == point.label ) 1 else 0
        }.sum()
//
        val dtFAccuracy = dtFTotalCorrect/trainingData.count
        println("dtFAccuracy="+dtFAccuracy)
        
        
        val testCorrect=testData.map{ testpoint=>
          val testrings= dtFmodel.predict(testpoint.features).round
          if(testrings == testpoint.label ) 1 else 0
        }.sum()
//
        val testAccuracy = testCorrect/testData.count
        println("testAccuracy="+testAccuracy)
//        
        
        val test_rawData=sc.textFile("/home/deploy/pkbigdata/Rings/testdata.csv").filter(line=> !line.contains("Sex"))
        val test_records=test_rawData.map(line=>line.split(","))
        val test_data=test_records.map{ r=>
           val mapped = r.map(_.replaceAll(r(1), sexMap(r(1)).toString()))
           val label=r(0).toInt
           val features=mapped.slice(1, r.size).map(d=>d.toDouble)
           
           LabeledPoint(label,Vectors.dense(features))
        }
        
        test_data.cache()
//        
        println("ID,Rings")
        val test_predicted=test_data.map(point => (point.label.toInt,dtFmodel.predict(point.features) round))
        test_predicted.collect().foreach(println)
    

//        
//        val test_filteredData = test_data.map { lp => 
//        LabeledPoint(lp.label, transformer.transform(lp.features)) 
//        }
//        
//        test_filteredData.cache()
//      
//        println("\"uid\",\"score\"")
//
////        val test_result=test_filteredData.map{ point => (point.label.toInt,if(dtModel.predict(point.features)>0.5) 1 else 0)}
//        val test_result=test_filteredData.map{ point => (point.label.toInt,dtModel.predict(point.features))}
//        test_result.collect().foreach(println)

    }
}