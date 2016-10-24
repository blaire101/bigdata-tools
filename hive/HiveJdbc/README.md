# HiveJdbc Remote Join Call Steps

## 1. startup metastore service

> bin/hive –service -help

metastore (bin/hive –service metastore)


## 2. startup hiveserver2 service

hiveserver2（bin/hive –service hiveserver2）
HiveServer2

> HiveServer2是HieServer改进版本，它提供给新的ThriftAPI来处理JDBC或者ODBC客户端，进行Kerberos身份验证，多个客户端并发

## 3. hiveserver2 ClI

> HS2还提供了新的CLI：BeeLine，是Hive 0.11引入的新的交互式CLI，基于SQLLine，可以作为Hive JDBC Client 端访问HievServer2，启动一个beeline就是维护了一个session.

## 4. java connect hiveserver2

![java connect hiveserver2][1]

[1]: http://192.168.184.10:99/backend/HiveJdbc/raw/master/images/HiveJdbcTest.png

注 : CDH CM 可直接启动 metastore、hiveserver2 service等，beeline 与 java connect hiveserver2 验证其一通过，就可以确定 hiveserver2 已经成功开启并可 remote join call。