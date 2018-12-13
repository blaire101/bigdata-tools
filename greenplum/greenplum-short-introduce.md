# Greenplum 学习笔记

![][1.1]

No.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | OLTP | OLAP
------- | ------- | -------
1. | 数据在系统中产生 | 本身不产生数据，基础数据来源于产生系统
2. | 基于交易的处理系统 | 基于查询的分析系统
3. | 牵扯的数据量很小 | 牵扯的数据量庞大 (复杂查询经常使用全表扫描等)
4. | 对响应时间要求非常高 | 响应时间与具体查询有很大关系
5. | 用户数量大，为操作用户 | 用户数量少，主要有技术人员与业务人员
6. | 各种操作主要基于索引进行 | 业务问题不固定，数据库的各种操作不能完全基于索引进行

## 1. Greenplum 介绍

Greenplum 是 基于数据库的分布式数据存储和并行计算 框架

> Greenplum TB级别表现非常优秀，单机性能比Hadoop快好几倍

### 1.1 Greenplum 历程

- 2003 年 诞生 greenplum
- 2010 年 收购 被 EMC 整合
- 2014 年 发布 4.3 version
- 2015 年 重回 open source, apache

### 1.2 Greenplum 架构

![][1.2]

> Greenplum实现了基于`数据库的分布式`数据存储和并行计算
> GoogleMapReduce实现的是基于`文件的分布式`数据存储和计算

### 1.3 Greenplum & Pg

PostgreSQL 非常先进的 ORDBMS， PostgreSQL 天生为扩展而生。

Mysql 查询优化器对于子查询、复制查询如多表关联、外关联的支持等较弱，Mysql 目前不支持[hash join][6]，缺少这关键功能非常致命，将难于在OLAP领域充当大任。基于MYSQL一到复杂多表关联性能就立马下降。

### 1.4 Greenplum 应用

Greenplum 数据引擎是为新一代数据仓库和`大规模分析处理`而建立的软件解决方案。 (Alibaba 2008年使用Greenplum)

> MPP : Massively Parallel Processing
> OLTP: On-Line Transaction Processing
> OLAP: On-Line Analytical Processing 

### 1.5 MPP 与 Hadoop

&nbsp;&nbsp;Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Greenplum MPP | Hadoop
------- | ------- | -------
存储模式 | 关系数据库行列表存储数据（有模式）| 文件切片分布式存储（无模式）
数据耦合 | Hash分布, 计算节点和存储紧密耦合 | hdfs文件切块后随机分配，节点数据无耦合
数据粒度 | 记录级的更小粒度（一般在1k以下）| 文件块级（缺省64MB）
查询计划 | MPP采用SQL并行查询计划 | Hadoop采用Mapreduce框架

为保证数据的高性能计算，MPP数据库节点和数据之间是紧耦合的，相反，Hadoop的节点和数据是没有耦合关系的. Hadoop的架构更加灵活-存储节点和计算节点的无关性

Hadoop架构，需要在原生的Mapreduce开发框架基础上的开发，需要技术人员谙熟于JAVA开发和并行原理，不仅业务分析人员无法使用，甚至技术人员也难以学习和操控。为了解决易用性的问题，近年来SQL-0N-HADOOP技术大量涌现出来，几乎成为当前Hadoop开发使用的一个技术热点趋势。

这些技术包括：Hive、Pivotal HAWQ、SPARK SQL、Impala、Prest、Drill、Tajo等等很多，这些技术有些是在Mapreduce上做了优化，例如Spark采用内存中的Mapreduce技术，号称性能比基于文件的的Mapreduce提高10倍；而有些则直接绕开了Mapreduce另起炉灶，如Impala、hawq采用借鉴MPP计算思想来做查询优化和内存数据Pipeline计算，以此来提高性能。

> MapReduce 编程困难, 不如 SQL 方便

## 2. Quick Start

Master 和 Segment 都是单独的 PostgreSQL数据库。

### 2.1 Greenplum 架构

![][2.1]

Client 只与 Master节点 交互，Client将SQL发给 Master，然后 Master对SQL分析后，分配给所有的 Segment 进行操作，并将汇总结果返回给客户端。

### 2.2 Greenplum 集群

![][2.2]

### 2.3 Greenplum 畅游

#### 2.3.1 访问方式

- psql cmd
- pgAdmin / navicat

#### 2.3.2 整体概况

- Greenplum 基于 PostgreSQL 8.2 开发
- Master不存储数据，Segment为数据节点

Student Table 存储在 GP 中

![][2.3]

#### 2.3.3 基本语法

```bash
[hdfs@node196 libin]$ psql -h 192.168.xx.xx -p xx -d testdb -U xx
psql (9.2.15, server 8.2.15)
WARNING: psql version 9.2, server version 8.2.
         Some psql features might not work.
Type "help" for help.
```

> psql -h192.168.181.xx -p2345 -dcom_db -Ucom_gp -c "select * from ods_dm_e_coupon limit 2"

**1. 语法介绍**

```sql
\h create
```

**2. CREATE TABLE**

- 需要指定表分布键
- 需要用某个字段分区，partition by
- like 类似 create table t1 as select * from t2 limit x
- inherits can extend table

分类策略 

 1. Hash 分布 (默认第一个字段，推荐显示指定)
 2. 随机分布 (distributed randomly 性能较差， 主键分布一般)

> like 创建的表，结构与原表一样，不指定分布键，默认与原表一样。
> 
> appendonly、压缩等特殊属性，不一定一样。

**3. SELECT**

**4. CREATE TABLE AS 与 SELECT INTO**

```sql
CREATE TABLE test2 AS SELECT * FROM test1 distributed by (id)
```

```sql
SELECT * INTO test4 from test1
```

> SELECT INTO 不能指定分布键，使用默认

**5. INSERT**

```sql
INSERT INTO test001 VALUES(100, 'tom'), (101, 'jim'); INSERT 0 2
```

> 注意 : 分布键 绝对不能为空，否则为 null。数据分布到一个节点。

**6. UPDATE**

不能批量对 分布key 执行 update 操作

**7. DELETE**

涉及 子查询，子查询结果还涉及数据重分布，这样报错

#### 2.3.4 数据类型

type| space| description | range
------- | ------- | ------- | -------
smallint | 2 | | -32768 ~ +32767
integer | 4 | | -2 147 483 648 ~ +2 147 483 647
bigint | 8 | | -
decimal | 变长 | | nolimit
numeric | 变长 | | nolimit
double precision | 4| | -
serial | 4 | 自增整数 | 1 ~ 2 147 483 647
bigserial | 8 | 大范围自增整数 |
varchar(n) | 变长 | | limit
char(n) | 定长 | |
text | 变长 | | nolimit
timestamp | 8 | 带不带时区，自己选择 |
date | 4 | 表示日期 |

#### 2.3.5 常用函数

[postgres 9.3 doc][7]

## Reference

- [JD阅读 : Greenplum企业级应用实战][4]
- [聊聊Greenplum的那些事][5]

[1.1]: /images/ops/greenplum-1.1.png
[1.2]: /images/ops/greenplum-1.2.png
[1.3]: /images/ops/greenplum-1.4.png
[4]: https://cread.jd.com/read/startRead.action?bookId=30189846&readType=1
[5]: http://dbaplus.cn/news-21-341-1.html
[6]: https://en.wikipedia.org/wiki/Hash_join
[2.1]: /images/ops/greenplum-2.1.png
[2.2]: /images/ops/greenplum-2.2.png
[2.3]: /images/ops/greenplum-2.3.png
[7]: http://www.postgres.cn/docs/9.3/