#!/bin/sh
cd `dirname $0`/.. && wk_dir=`pwd` && cd -
source ${wk_dir}/util/env

###### create ods_dm_shop ##########
table_name="ods_dm_shop"
hql="create external table if not exists ${table_name}
(
 id bigint,
 category_id bigint COMMENT 'shopCategory_id',
 region_id bigint COMMENT 'City Area Administration encoding',
 cityCode varchar(6) COMMENT 'City Administration encoding',
 merchant_id bigint COMMENT 'Belongs merchant',
 balance_id bigint COMMENT 'Cash account. Has been abandoned, do not recommend the use of',
 balance decimal(12,2) COMMENT 'Merchant balance (is BalanceTransaction table.Trigger statistics getted)',
 address varchar(255),
 contact varchar(255) COMMENT '[phone number]',
 domain varchar(255) COMMENT 'web adress',
 shopHours varchar(255) COMMENT 'business Hours',
 banner_id bigint COMMENT 'top picture',
 avatar_id bigint COMMENT 'Head portrait',
 name varchar(255) COMMENT 'short name',
 fullName varchar(255) COMMENT 'full name',
 visible boolean COMMENT 'Whether in front web show',
 brand_id bigint COMMENT 'Brand (has not started)',
 wechat varchar(255) COMMENT 'webchat_id',
 weibo varchar(255) COMMENT 'weibo_id',
 stars double COMMENT 'User scoring (Grade)',
 tag varchar(255) COMMENT 'tag',
 position_id bigint COMMENT 'position coordinate',
 printer_enable boolean COMMENT 'Whether enable 1. enabled 0. not enabled',
 printer_ip varchar(100) COMMENT 'print server IP',
 printer_port varchar(50) COMMENT 'print server port',
 enable_shift tinyint COMMENT 'Whether shift(1/0)',
 visible_shift_receivable_data tinyint COMMENT 'Whether show [account receivable cash] in the shifting (1/0)',
 enable_multiple_payment tinyint COMMENT 'Whether support multiple payments(0. not enable 1. enable.  default is 0)',
 statisticsDate varchar(50) COMMENT 'statistics begin time',
 createDate timestamp,
 modifyDate timestamp,
 deleted boolean,
 need_sy boolean,
 sy_start_time timestamp,
 sy_end_time timestamp,
 slogans string,
 distribution string,
 signboards_id bigint
)
partitioned by (dt string)
row format delimited fields terminated by '\001' collection items terminated by ',' map keys terminated by ':' lines terminated by '\n'
stored as rcfile
location '${ods_hive_dir}/${table_name}';
"
echo "$hql"
${HIVE} -e "$hql"
###### create ods_dm_shop_tmp ##########
table_name="ods_dm_shop_tmp"
hql="create external table if not exists ${table_name}
(
 id bigint,
 category_id bigint COMMENT 'shopCategory_id',
 region_id bigint COMMENT 'City Area Administration encoding',
 cityCode varchar(6) COMMENT 'City Administration encoding',
 merchant_id bigint COMMENT 'Belongs merchant',
 balance_id bigint COMMENT 'Cash account. Has been abandoned, do not recommend the use of',
 balance decimal(12,2) COMMENT 'Merchant balance (is BalanceTransaction table.Trigger statistics getted)',
 address varchar(255),
 contact varchar(255) COMMENT '[phone number]',
 domain varchar(255) COMMENT 'web adress',
 shopHours varchar(255) COMMENT 'business Hours',
 banner_id bigint COMMENT 'top picture',
 avatar_id bigint COMMENT 'Head portrait',
 name varchar(255) COMMENT 'short name',
 fullName varchar(255) COMMENT 'full name',
 visible boolean COMMENT 'Whether in front web show',
 brand_id bigint COMMENT 'Brand (has not started)',
 wechat varchar(255) COMMENT 'webchat_id',
 weibo varchar(255) COMMENT 'weibo_id',
 stars double COMMENT 'User scoring (Grade)',
 tag varchar(255) COMMENT 'tag',
 position_id bigint COMMENT 'position coordinate',
 printer_enable boolean COMMENT 'Whether enable 1. enabled 0. not enabled',
 printer_ip varchar(100) COMMENT 'print server IP',
 printer_port varchar(50) COMMENT 'print server port',
 enable_shift tinyint COMMENT 'Whether shift(1/0)',
 visible_shift_receivable_data tinyint COMMENT 'Whether show [account receivable cash] in the shifting (1/0)',
 enable_multiple_payment tinyint COMMENT 'Whether support multiple payments(0. not enable 1. enable.  default is 0)',
 statisticsDate varchar(50) COMMENT 'statistics begin time',
 createDate timestamp,
 modifyDate timestamp,
 deleted boolean,
 need_sy boolean,
 sy_start_time timestamp,
 sy_end_time timestamp,
 slogans string,
 distribution string,
 signboards_id bigint
)
row format delimited fields terminated by '\001' collection items terminated by ',' map keys terminated by ':' lines terminated by '\n'
location '${tmp_hive_dir}/${table_name}';
"
echo "$hql"
${HIVE} -e "$hql"
