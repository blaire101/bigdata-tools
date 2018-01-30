# Flexible Task Scheduling Microframework

> 大数据离线分析模块开发Demo

日期 | 版本 | 说明 | 修改人员 | 确认人员
:--- | :-- |:--- | :-- |:--- 
2017-12-15 | 4.0 | yyyy-mm-dd | Blair Chan | Blair Chan 

## 目标

+ 1. 提供一些 best practice
+ 2. 提高各模块结构及代码的一致性
+ 3. 降低开发新模块的成本
+ 4. 便于离线大数据分析
+ 5. 当然它也适用于对任何离线Job进行调度

```
  这是一个 hive 配合 shell 等其他语言写成的灵活调度框架.
     该示例模块架 适用于离线分析，特别是每天跑的crontab任务，或者是每周、每月跑的任务
```

## 1. 代码规范

- 1. 对 Hive 表的操作，如基本SQL不能满足需求，则建议优先采用 Java UDF/UDAF 的方式
- 2. 非 Hive 操作, 推荐优先采用python版 streaming 方式或者Java语言实现方式
- 3. 每个模块建议给出准确的输入、输出格式定义注释说明.

## 2. 结构规范

### 2.1 模块目录

+ 每个模块为一个目录，模块名 一般与其中 主代码目录 名称一致

```bash
# ~/ghome/xgitlab/group-data/bigdata-offline-demo [master ✗ (0cdd403)] [14:43:10]
➜ ll
total 40
-rw-r--r--   1 blair  staff   106B Dec 15 14:12 LICENSE
-rw-r--r--@  1 blair  staff   4.9K Dec 15 14:43 README.md
drwxr-xr-x  10 blair  staff   320B Dec 15 14:02 bigdata-offline-demo
drwxr-xr-x   4 blair  staff   128B Dec 15 14:11 docs
```

**目录功能说明**

名称 | 说明
------- | -------
bigdata-offline-demo | 主代码目录 名称
README.md | 主要说明
LICENSE | 许可说明
docs | 详细文档

### 2.2 主代码目录

> **bigdata-offline-demo/bigdata-offline-demo/**

```bash
# ~/ghome/xgitlab/group-data/bigdata-offline-demo/bigdata-offline-demo [master ✗ (0cdd403)] [14:44:28]
drwxr-xr-x   5 blair  staff   160B Dec 15 14:02 alert
drwxr-xr-x   6 blair  staff   192B Dec 15 14:02 conf
drwxr-xr-x   3 blair  staff    96B Dec 15 14:02 create_table
drwxr-xr-x   3 blair  staff    96B Dec 15 14:08 crontab_job
drwxr-xr-x   3 blair  staff    96B Dec 15 14:02 flag
drwxr-xr-x  40 blair  staff   1.3K Dec 15 14:02 log
drwxr-xr-x   3 blair  staff    96B Dec 15 14:08 script
drwxr-xr-x   8 blair  staff   256B Dec 15 14:04 util
```

**主代码目录功能说明**

目录 | 说明
:--- | :--
── alert | 报警封装
── conf | 配置文件
──create_table | 建表脚本
── crontab_job | crontab 任务脚本。(crontab任务脚本以crontab_job为前缀, 检测任务依赖关系, 调用主逻辑脚本等)
── flag | 标记文件。(标志该模块已经开始运行，或者运行完毕)
── log | 日志文件。 (如脚本失败可根据log追查定位失败原因) |
── script | 主脚本文件 |
── util | 工具脚本。(主要包含写log脚本, hadoop file / local file / hive check 等封装, 初始化环境目录等)
|
|
── jar | jar包。 (如无则不需要建立)
── java | java (udf udaf) 源代码。 (如无则不需要建立)

+ script目录 主要存放 shell 脚本，有需要也存放 python 脚本。
+ java 代码需要放入 java目录 
+ 如果该模块，script目录脚本较多，􏰀可以在 script dir之下建立子目录􏰀如􏰂 :

        ├── script
          ├── sub_module_1 子模块目录 
          ├── sub_module_2 子模块目录
          
### 2.2 项目模板 

+ 提供公共的项目模板. 􏰀统一shell脚本代码􏰄结构􏰄 日志􏰄配置规范􏰁 等
+ 项目模板可仿照本模块􏰂 : 

    ```
    http://gitlab.***/data/bigdata-offline-demo.git
    ```
    
+ 1). 变量命名􏰂

   ```
   自有变量采用小写􏰀. export出的环境变量采用大写􏰁
     hive 表命名 : 
      1. 原始数据表，数据挖掘团队建立的 则 采用命名方式为 ods_dm (original data stream, data_mining)开头
      2. 非原始数据表 数据挖掘团队建立的 则 采用命名方式为 mds_dm (modified data stream , data_mining)开头
      3. 临时数据表 数据挖掘团队建立的 则 采用命名方式为 tmp_dm (temp data stream , data_mining)开头
```
   
+ 2). 配置文件 (conf目录下)

   ```
   default.conf􏰂 配置公共参数􏰂程序路径􏰄hadoop 用户等􏰁
   vars.conf    配置任务参数􏰂 hive表名􏰄参数设置, 以及其他变量等􏰁
   alert.conf􏰂   配置邮件报警接收人􏰁 
```
        
+ 3). 输入输出

   ```
   1. 如果存在输入源多种数据格式(rcfile+lzo+textfile)的情况􏰀推荐采用生成临时的统一格式的数据表的方式处理􏰁 
   2. hive 表 输出原则上均采用rcfile格式􏰁。
         (当然现在存储便宜，所以很多时候为了操作方便，也可采用text格式存储，但仍然推荐ods层面表统一为rcfile格式)
   3. 非hive表 输出采用rcfile或者lzo格式均可􏰁
```

+ 4). hive 建表示例.

   ```bash
table_name="${table_ods_e_coupon}"
hql="create external table if not exists ${table_name}
(
    id bigint COMMENT '序号',
    mobile_number varchar(16) COMMENT '领取电子券的手机号',
    coupon_order_number varchar(32) COMMENT '购买电子券时的订单编号',
    dt string
) COMMENT '实际电子券'
row format delimited fields terminated by '\001' collection items terminated by ',' map keys terminated by ':' lines terminated by '\n'
stored as rcfile
location '${OSS_URL}/${ods_hive_dir}/${table_name}';
"
echo "$hql"
${HIVE} -e "$hql"
```
 
  说明

  ```
  1. 推荐百万级以上记录的 hive 表建立时指定分区，一般string dt=yyyy-mm-dd  
  2. 数据量不大，又不是按照天增加很多数据量的表，则不需要指定分区   
  3. 分区 string dt 一般建议为 yyyy-MM-dd 格式  (dt 取自 : date, 默认意思为数据产生日期)
  4. hive 建表时指定格式，列与列之间分隔符
  5. ${hive_dir}, mds 表为 bucket_name/data_mining/dm/mds/ 
                    ods 表为 bucket_name/data_mining/dm/ods/
                            bucket名称 + 部门或大项目组名称 + 团队名称 + 层级       
```


+ 5). 报警规范

  ```
  check_success 为封装好的，检测上一条语句执行执行成功，后自动发报警的函数。
  (发报警邮件标题以 模块名--任务脚本路径名--任务状态及原因-日期 来设置。便于快速定位问题)
  ```

## 3. 开发流程

### 3.1 拷贝模块 demo

- copy 本模块，并重命名模块名

### 3.2 修改配置 conf

- 修改 conf/default.conf 中用不到的 rds 相关变量
- 修改 conf/vars.conf 中相关变量

### 3.3 建表语句

根据 create\_table/create\_table\_e\_coupon.sh 样例建表脚本，编写属于你自己的建表脚本 

```bash
[data_mining@emr-gw bigdata-offline-demo]$ ll create_table/
total 8
-rwxr-xr-x 1 data_mining hadoop 7946 Dec 13 14:30 create_table_e_coupon.sh
```

### 3.4 主脚本

- 编写 script 下你的主脚本
- 根据 script/ods\_dm\_e\_coupon.sh 样例脚本，编写属于你自己的主脚本 

```bash
[data_mining@emr-gw bigdata-offline-demo]$ ll script/
total 144
-rwxr-xr-x 1 data_mining hadoop   2753 Dec 15 16:58 ods_dm_e_coupon.sh
```

> 不用拉取数据的，则不需要脚本开头的 source ${util_dir}/my\_functions 这句代码。

### 3.5 调度脚本

- 编写 crontab_job 下你的调度脚本
- 仿照 crontab\_job\_ods\_e\_coupon.sh 编写你主脚本对应的 调度脚本

### 3.6 Linux crontab 定时任务

在 linux crontab 中，增加需要定时启动的你的调度脚本 crontab\_job\_your\_script.sh

```
[data_mining@emr-gw online]$ crontab -l
10 02 * * * source /etc/bashrc; sh /home/data_mining/hero/online/bigdata-offline-demo/bigdata-offline-demo/crontab_job/crontab_job_ods_e_coupon.sh
```


注 : 如有其他问题，再商议
