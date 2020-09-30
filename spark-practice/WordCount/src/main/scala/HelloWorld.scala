/* HelloWorld.scala */
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf

object HelloWorld {
    def main(args: Array[String]): Unit = {
      println("start...")
      val logFile = "src/data/simple.txt" // Should be some file on your system
      val conf = new SparkConf().setAppName("wordCount") // .setMaster("spark:/master:7077")
      val sc = new SparkContext(conf)
      val logData = sc.textFile(logFile, 2).cache()
      val numAs = logData.filter(line => line.contains("a")).count()
      val numBs = logData.filter(line => line.contains("b")).count()
      println("Lines with a: %s, Lines with b: %s".format(numAs, numBs))
    }

//  val product = tuple._2.map{case Rating(user, product, score) => (product.toString, score.toString)}
//  val originResultRdd = model.recommendProductsForUsers(numRecommender.toInt)
//    .map(tuple => {
//      val uid = tuple._1
//      val product = tuple._2.map{case Rating(user, product, score) => (product.toString, score.toString)}
//      (uid, product)
//    })
//    .flatMap{case (uid, product) => {
//      product.map{case (photoId, score) => (uid.toLong, (photoId.toLong, score.toDouble))
//      }
//    }}
}
