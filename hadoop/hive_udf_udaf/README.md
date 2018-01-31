user_bhv 里面的代码为 UDAF 的 demo 例子.

# Hive 中 udf、udaf 的使用

Hive 是基于 Hadoop 中的 MapReduce，提供 HQL 查询的数据仓库. 

Hive 是一个很开放的系统，很多内容都支持用户定制. 如 : 文件格式、MR脚本、自定义函数、自定义聚合函数 等.

<!-- more -->

## User Defined Function

编写 UDF函数 的时候需要注意一下几点：

1. 自定义 UDF 需要继承 org.apache.hadoop.hive.ql.UDF
2. 需要实现 `evaluate` 函数

以下是两个数求和函数的UDF。evaluate函数代表两个整型数据相加

```java
package hive.connect;  
  
import org.apache.hadoop.hive.ql.exec.UDF;  
  
public final class Add extends UDF {

    public Integer evaluate(Integer a, Integer b) {  
        if (null == a || null == b) {  
            return null;  
        } 
        return a + b;  
    }  
}  
```

## User Defined Aggregation Funcation

函数类需要继承 **UDAF** 类，内部类 **Evaluator** 需要实现 **UDAFEvaluator** 接口.

Evaluator 需要实现 init、iterate、terminatePartial、merge、terminate 这几个函数.

1. `init`函数实现接口 UDAFEvaluator 的 init 函数.
2. `iterate`接收传入的参数，并进行内部的轮转。其返回类型为 boolean.
3. `terminatePartial`无参数，其为 iterate 函数轮转结束后，返回轮转数据.
4. `merge` 接收 terminatePartial 的返回结果，进行数据 merge 操作，其返回类型为boolean.
5. `terminate` 返回最终的聚集函数结果.

## Summary

1. 重载 evaluate 函数
2. UDF 函数中参数类型可以为Writable，也可为java中的基本数据对象。
3. UDF 支持变长的参数。
4. Hive 支持隐式类型转换。
5. 客户端退出时，创建的临时函数自动销毁。
6. evaluate函数必须要返回类型值，空的话返回null，不能为void类型。
7. UDF 和 UDAF 都可以重载。
8. 查看函数 SHOW FUNCTIONS;
