## 1. datax json

orders、shop、region

```
/data0/dm/online/datax_home/conf/company_com.ext
```

card

```
/data0/dm/online/datax_home/conf/company_member.ext
```

## 2. ext

### 2.1 ext.ext\_dm\_orders

```sql
CREATE EXTERNAL web TABLE ext.ext_dm_orders (
    id bigint,
    orderNumber varchar(32),
    device_number varchar(100),
    businessType varchar(255),
    businessId bigint,
    totalAmount decimal(12,2),
    paidAmount decimal(12,2),
    actuallyPaid decimal(12,2),
    type varchar(500),
    status varchar(16),
    refund_status varchar(50),
    refund_amount decimal(12,2),
    operator_id bigint,
    manager_id int,
    member_id bigint,
    operator_session_code varchar(255),
    success_session_code varchar(255),
    identifier varchar(255),
    peoples int,
    takeAway boolean,
    discount double precision,
    posTransaction_id bigint,
    counter bigint,
    trade_time timestamp,
    refund_time timestamp,
    clientType varchar(50),
    appVersion varchar(50),
    sync_type varchar(100),
    sync_time timestamp,
    createDate timestamp,
    modifyDate timestamp,
    server_time timestamp,
    server_trade_time timestamp,
    x_card_user_id varchar(32),
    source smallint
) LOCATION (
    'http://192.168.xx.xx:8900/company_com.ext/orders.txt__0b7e8f69_ac7d_42b5_b17e_6ff97c2586de'
) format 'text' (DELIMITER '\t' NULL AS 'null');
```

> comment del this
> SELECT * from ext.ext\_dm\_orders limit 200;

### 2.2 ext.ext\_dm\_shop

```sql

DROP EXTERNAL TABLE ext.ext_dm_shop;
CREATE EXTERNAL web TABLE ext.ext_dm_shop (
    id bigint,
    category_id bigint,
    region_id bigint,
    cityCode varchar(6),
    merchant_id bigint,
    balance_id bigint, 
    balance decimal(12,2),
    address varchar(255),
    contact varchar(255),
    domain varchar(255),
    shopHours varchar(500),
    banner_id bigint,
    avatar_id bigint,
    name varchar(255),
    fullName varchar(255),
    visible boolean,
    brand_id bigint,
    wechat varchar(255),
    weibo varchar(255),
    stars double precision,
    tag varchar(255),
    position_id bigint,
    printer_enable boolean,
    printer_ip varchar(100),
    printer_port varchar(50),
    enable_shift smallint,
    visible_shift_receivable_data smallint, 
    enable_multiple_payment smallint,
    statisticsDate varchar(50),
    createDate timestamp,
    modifyDate timestamp,
    deleted boolean,
    need_sy boolean,
    sy_start_time timestamp,
    sy_end_time timestamp,
    slogans varchar,
    distribution varchar,
    signboards_id bigint
) LOCATION (
       'http://192.168.xx.xx:8900/company_com.ext/shop.txt__bf685ddc_a29b_4116_85bf_1cec1a23279d'
   ) format 'text' (NULL AS 'null');
```

### 2.3 ext.ext\_dm\_region

```sql
CREATE EXTERNAL web TABLE ext.ext_dm_region (
    id bigint,
    districtCode int,
    districtName varchar(15),
    cityCode int,
    cityName varchar(15),
    provinceCode int,
    provinceName varchar(8)
) LOCATION (
       'http://192.168.xx.xx:8900/company_com.ext/region.txt__e350d230_1e43_4083_8b39_2c9a1218174b'
   ) format 'text' (NULL AS 'null');
```

### 2.4 ext.ext\_dm\_card

```sql
CREATE EXTERNAL web TABLE ext.ext_dm_card (
  id bigint,
  business_id bigint,
  business_type varchar(255),
  card_type varchar(255),
  mobile varchar(40),
  card_level_id bigint,
  card_level_name varchar(255),
  shop_id bigint,
  shop_name varchar(255),
  show_shop_id varchar(255),
  show_shop_name varchar(255),
  prepaid_card_id bigint,
  physical_card_id bigint, 
  physical_card_number varchar(255),
  operator_id bigint,
  operator_session_code varchar(255),
  source varchar(20),
  create_time timestamp,
  update_time timestamp,
  deleted smallint
) LOCATION (
       'http://192.168.xx.xx:8900/company_member.ext/card.txt__67790c73_cd89_462e_92ae_72e985c19d91'
   ) format 'text' (NULL AS 'null');
```

> select * from ext.ext\_dm\_card limit 2;

## 3. ods

### 3.1 ods.ods\_dm\_orders

```sql
CREATE TABLE ods.ods_dm_orders AS SELECT
    *
FROM
    ext.ext_dm_orders;
```

### 3.2 ods.ods\_dm\_shop

```sql
CREATE TABLE ods.ods_dm_shop AS SELECT
    *
FROM
    ext.ext_dm_shop;
```

### 3.3 ods.ods\_dm\_region

```sql
CREATE TABLE ods.ods_dm_region AS SELECT
    *
FROM
    ext.ext_dm_region;
```

### 3.4 ods.ods\_dm\_card

```sql
CREATE TABLE ods.ods_dm_card AS SELECT
    *
FROM
    ext.ext_dm_card;
```

## 4. mds

### 4.1 dw.mds\_dm\_user\_shop\_data 用户在

```sql
CREATE TABLE dw.mds_dm_user_shop_data (
	id bigserial,
    member_id bigint,
    mobile varchar,    
    shop_id bigint,
    sum_count int,
    sum_paid decimal(12,2),
    last_trade_time timestamp
) WITH (
	appendonly = TRUE,
	compresslevel = 5
) distributed BY (id);
```

```sql
INSERT INTO dw.mds_dm_user_shop_data (
    member_id,
    mobile,    
    shop_id,
    sum_count,
    sum_paid,
    last_trade_time
)
SELECT
	tt1.member_id AS member_id,
	tt2.mobile AS mobile,
	tt1.shop_id AS shop_id,
	tt1.sum_count AS sum_count,
	tt1.sum_paid AS sum_paid,
	tt1.last_trade_time AS last_trade_time
FROM
	(
		SELECT
			t1.member_id AS member_id,
			t1.businessId AS shop_id,
			COUNT(t1.id) AS sum_count,
			SUM(t1.actuallyPaid) AS sum_paid,
			MAX(t1.trade_time) AS last_trade_time
		FROM
			ods.ods_dm_orders t1
		WHERE
			t1.member_id IS NOT NULL
		AND t1.businessType = 'SHOP'
		GROUP BY
			t1.member_id,
			t1.businessId
	) tt1
LEFT JOIN ods.ods_dm_card tt2 ON tt1.member_id = tt2.id;
```

### 4.2 dw.mds\_dm\_member\_profile

```sql
DROP TABLE dw.mds_dm_member_profile;
CREATE TABLE dw.mds_dm_member_profile (
    id bigserial,
    member_id bigint,
    mobile varchar, 
    favor_shop_id bigint,
    favor_shop_name varchar,
    favor_shop_order_count int,
    favor_shop_sum_paid decimal(12,2),
    favor_shop_last_trade_time timestamp,
    province_name varchar,
    city_name varchar,
    district_name varchar,
    sum_count int,
    sum_paid decimal(12,2),
    last_trade_time timestamp
) WITH (
    appendonly = TRUE,
    compresslevel = 5
) distributed BY (id);
```

```sql
INSERT INTO dw.mds_dm_member_profile (
    member_id,
    mobile, 
    favor_shop_id,
    favor_shop_name,
    favor_shop_order_count,
    favor_shop_sum_paid,
    favor_shop_last_trade_time,
    province_name,
    city_name,
    district_name,
    sum_count,
    sum_paid,
    last_trade_time
)
SELECT
    table1.member_id,
    table1.mobile,
    table1.favor_shop_id,
    table1.favor_shop_name,
    table1.favor_shop_order_count,
    table1.favor_shop_sum_paid,
    table1.favor_shop_last_trade_time,
    table1.province_name,
    table1.city_name,
    table1.district_name,
    table2.sum_count,
    table2.sum_paid,
    table2.last_trade_time
FROM
(SELECT
    member_id,
    MAX(mobile) AS mobile,
    MAX(favor_shop_id) AS favor_shop_id,
    MAX(favor_shop_name) AS favor_shop_name,
    MAX(favor_shop_order_count) AS favor_shop_order_count,
    MAX(favor_shop_sum_paid) AS favor_shop_sum_paid,
    MAX(favor_shop_last_trade_time) AS favor_shop_last_trade_time,
    MAX(province_name) AS province_name,
    MAX(city_name) AS city_name,
    MAX(district_name) AS district_name
FROM
    (
        SELECT
            tt1.member_id AS member_id,
            tt2.mobile AS mobile,
            tt2.shop_id AS favor_shop_id,
            tt3.shop_name AS favor_shop_name,
            tt1.max_count AS favor_shop_order_count,
            tt2.sum_paid AS favor_shop_sum_paid,
            tt2.last_trade_time AS favor_shop_last_trade_time,
            tt3.province_name AS province_name,
            tt3.city_name AS city_name,
            tt3.district_name AS district_name
        FROM
            (
                SELECT
                    t1.member_id AS member_id,
                    max(t1.sum_count) AS max_count
                FROM
                    (
                        SELECT
                            *
                        FROM
                            dw.mds_dm_user_shop_data
                    ) t1
                GROUP BY
                    t1.member_id
            ) tt1
        INNER JOIN (
            SELECT
                *
            FROM
                dw.mds_dm_user_shop_data
        ) tt2 
        ON (tt1.member_id = tt2.member_id AND tt1.max_count = tt2.sum_count)
        LEFT JOIN (
            SELECT
                t1.shop_id AS shop_id,
                MAX(t1.shop_name) AS shop_name,
                MAX(shop_full_name) AS shop_full_name,
                MAX(province_name) AS province_name,
                MAX(city_name) AS city_name,
                MAX(district_name) AS district_name
            FROM
                (
                    SELECT
                        s1.id AS shop_id,
                        s1. NAME AS shop_name,
                        s1.fullName AS shop_full_name,
                        r1.provinceName AS province_name,
                        r1.cityName AS city_name,
                        r1.districtName AS district_name
                    FROM
                        ods.ods_dm_shop s1
                    LEFT JOIN ods.ods_dm_region r1 ON s1.region_id = r1.id
                ) t1
            GROUP BY
                t1.shop_id
        ) tt3 ON tt2.shop_id = tt3.shop_id
) t
GROUP BY
    t.member_id
) table1
LEFT JOIN
(
SELECT
    t1.member_id AS member_id,
    COUNT (t1.id) AS sum_count,
    SUM (t1.actuallyPaid) AS sum_paid,
    MAX (t1.trade_time) AS last_trade_time
FROM
    (
        SELECT
            *
        FROM
            ods.ods_dm_orders
        WHERE
            member_id IS NOT NULL
        AND businessType = 'SHOP'
    ) t1
GROUP BY
    t1.member_id
) table2
ON table1.member_id = table2.member_id
ORDER BY sum_count DESC;
```
