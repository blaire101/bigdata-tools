---
title: Greenplum ods
toc: true
date: 2017-01-20 15:28:21
categories: [devops]
tags: Greenplum
---

[code : github ext_ods_table][github1]

<!-- more -->

```bash
运行本模块之前 :

cd ext_ods_table
mkdir log flag
mkdir -p log/crontab
mkdir data

构造 datax json file， put it to **data** 目录
```

## 1. Needs

&nbsp;&nbsp;&nbsp;&nbsp;程序自动化拉取数据进入原始层 ODS
 
## 2. Data Flow

![ods flow][0]

> 具体请以实际线上代码 为准

## 3. Involved technology

1. [Shell][1]
2. [Datax][2]
3. [PostgreSQL][3]
4. [Greenplum][4]
5. [Pentaho kettle][6]

> [gpfdist protocol][5]

## 4. Main Code Flow

(1). linux crontab

```bash
*/5 00-19 * * * source /etc/bashrc; sh /data0/dm/online/ext_ods_table/crontab_job/crontab_job_ods_shop.sh
```

> source /etc/bashrc; 环境设置

(2). crontab\_job\_ods\_shop.sh

```bash
...
sh ods_dm_shop.sh ${d1}
...
```

(3). ods\_dm\_shop.sh

```bash
###############################################################################
#
# @date:   2017.01.20
# @desc:   mysql data -> ext shop -> ods shop
#
###############################################################################

cd `dirname $0`/.. && wk_dir=`pwd` && cd -
source ${wk_dir}/util/env
source ${util_dir}/my_functions

begin_time="2010-01-01"
end_time=${d1}

import_gpdata_from_rds1 ${begin_time} ${end_time} ${data_dir}/xkeshi_com.ext/mysql2textfile-shop.json
check_success

echo_ex "${data_integration}/kitchen.sh -file=${ktrs_dir}/ods_shop.kjb"

${data_integration}/kitchen.sh -file=${ktrs_dir}/ods_shop.kjb
check_success

echo_ex "import shop end"

exit 0
```

## Reference

[0]: /images/ops/greenplum-ods-flow.png

[1]: https://zh.wikipedia.org/zh-hans/Unix_shell
[2]: https://github.com/alibaba/DataX/
[3]: https://en.wikipedia.org/wiki/PostgreSQL
[4]: http://dbaplus.cn/news-21-341-1.html
[5]: http://www.greenplumdba.com/gpfdist
[6]: http://www.pentaho.com/

[github1]: https://github.com/blair101/language/tree/master/greenplum
