# 大数据离线分析模块开发规范


| 日期 | 版本 | 说明 | 修改人员| 确认人员 |
| :--- | :-- |:--- | :-- |:--- | 
| 2015-12-09 | 1.0 | 初版 | 布莱尔 | Blair Chan |
| 2015-12-09 | 2.0 | 第二版 | 布莱尔 | Blair Chan |

### 目标
===

+ 1. 提供一些 best practice
+ 2. 提高各模块结构及代码的一致性
+ 3. 降低开发新模块的成本dt大数据离线分析模块开发规范
+ 4.便于离线大数据分析
           
        这是一个 hive 配合 shell 等其他语言的代码框架.
           该示例模块架 适用于离线分析，每天跑的crontab任务，或者是每周、每月跑的任务


### 1. 代码规范
===

+ 1). 对 Hive 表的操作，建议优先采用 Java UDF/UDAF 的方式
+ 2). 非 Hive 操作, 采用 streaming 方式或者Java语言实现方式
         
        如 streaming 实现, 编程语言推荐优先采用python。
           如果需要依赖第三方的c++库, 再考虑用c++实现。 
+ 3). 每个模块建议给出准确的输入、输出格式定义注释说明.

### 2. 结构规范

#### 2.1 目录结构

+ 每个模块一个根目录包括如下子目录

| 目录 | 说明|
| :--- | :-- |
| ── alert | 发送报警的脚本 |  
| ── conf | 配置文件 |
| ──create_table | 建表语句 |
| ── crontab_job | crontab 任务脚本。(crontab任务脚本以crontab_job为前缀) |
| ── data | 数据文件。(如没有数据则不需要该目录) |
| ── flag | 标记文件。(标志该模块已经开始运行，或者运行完毕) |
| ── jar | jar包 |
| ── java | java源代码 |
| ── cplus | c++源代码。 (如没有则不需要该目录) |
| ── lib | c++的so文件。 (如没有则不需要该目录) |
| ── log | 日志文件。 (如脚本失败可根据log追查定位失败原因) |
| ── script | 主脚本文件 |
| ── util | utility脚本。(主要包含写log脚本、hive check封装, 初始化环境目录等)
+ script目录 主要存放 shell 和 python 代码􏰁 
+ java 代码需要放入 java目录 
+ 如果该模块，script目录脚本较多，􏰀可以在 script dir之下建立子目录􏰀如􏰂 :

        ├── script
          ├── sub_module_1 子模块目录 
          ├── sub_module_2 子模块目录
#### 2.2 项目模板 

+ 提供公共的项目模板. 􏰀统一shell脚本代码􏰄结构􏰄 日志􏰄配置规范􏰁 等
+ 项目模板可仿照如下模块􏰂 : 

   ```
   https://github.com/libean/hadoop-spark/tree/master/hive/hive-dev-demo/ods_table
   ```
        
+ 1). 变量命名􏰂

        自有变量采用小写􏰀. export出的环境变量采用大写􏰁
        hive 表命名 : 
           1. 原始数据表，数据团队建立的 则 采用命名方式为 ods_dm (original data stream, data members (manager) )开头
           2. 非原始数据表 数据团队建立的 则 采用命名方式为 mds_dm (modified data stream , data members (manager) )开头

         其他 : 推荐 hive 表建立时指定分区，一般string dt=yyyymmdd
         
  个人假定举例 :      
  
         如 : 原始数据 RDS orders, RDS shop 信息保留绝大部分字段进入 
         hive table。 ods_dm_orders 和 ods_dm_shop. 两表join出一些必要
         字段 insert overvide 到 mds_dm_ordershop, 每天运行一次，之后可根据
          mds_dm_ordershop 插入 (hive external table 直连 ES) 或者 (写 UDF 通过 Mapreduer 写入 ES)，展示在 kibana。
         

+ 2). 配置文件 (conf目录下)

        default.conf􏰂 配置公共参数􏰂程序路径􏰄hadoop 用户等􏰁
        vars.conf 配置任务参数􏰂 hive表名􏰄参数设置, 以及其他变量等􏰁
        alert.conf􏰂 配置邮件和短信报警接收人􏰁 
        
        
+ 3). 输入输出

        如果存在输入源多种数据格式(rcfile+lzo+非压缩)的情况􏰀推荐采用生成临时的统一格式的数据表的方式处理􏰁 hive表输出原则上均采用rcfile格式􏰁。非hive表输出采用rcfile或者lzo格式均可􏰁。
+ 4). hive 建表示例.

  ~~~ shell
table_name="mds_dm_ordershop_demo"
hql="create external table if not exists ${table_name}
(
  id string comment '用户标识',
  businessType string comment '类型'
)
partitioned by (dt string)
row format delimited fields terminated by '\001' collection items terminated by ',' map keys terminated by ':' lines terminated by '\n'
location '${mds_hive_dir}/${table_name}';
"
~~~

  说明

  ```
  (1). 分区 dt 一般建议为 yyyyMMdd 格式。  (dt 取自 : date)
  (2). ${hive_dir}, mds 表为 /dc_ext/xbd/dm/mds/ 
                   ods 表为 /dc_ext/xbd/dm/ods/
  (3).  hdfs 路径 :  /dc_ext/xbd/dm/ods/ 
       释义为 : data center/x big data/data members(manger)/ original data stream 
       数据中心 / 所属业务线(某公司大数据) / (所属组) 数据团队 / 原始数据流                 
```


+ 5). 报警规范

        报警格式􏰂 :
            当前的报警脚本需要传递3个参数􏰀,模块名+前2个参数 用在标题中􏰀, 第3个是正文􏰁 
    
        (发报警邮件标题以 模块名--任务脚本路径名--任务状态及原因-日期 来设置。便于快速定位问题)


注 : 如有其他问题，再商议
