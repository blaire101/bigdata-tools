# Greenplum dev Flow

## 1. Rds import oss

通过 datax 从 mysql 导出数据到 OSS


组装 : mysql2oss-e_coupon.json

```xml
{
    "job": {
        "content": [
        {
            "reader": {
                "name": "mysqlreader",
                    "parameter": {
                        "username": "xx",
                        "password": "xx",
                        "connection": [
                        {
                            "jdbcUrl": [
                                "jdbc:mysql://192.168.184.xx:port"
                                ],
                            "table": [
                                "rds-lib-name.e_coupon"
                                ]
                        }
                        ],
                        "column":[
                            "id",
                            "x_card_user_id",
                            "coupon_discount_code",
                            ...
                            "order_merchant_id"
                        ],
                        "where": "created_time BETWEEN '2016-01-01 00:00:00' AND '2017-01-05 23:59:59'"
                    }
            },
                "writer": {
                    "name": "osswriter",
                    "parameter": {
                        "accessId": "xx",
                        "accessKey": "xx",
                        "bucket": "company-name-data",
                        "encoding": "UTF-8",
                        "endpoint": "http://oss-cn-hangzhou.aliyuncs.com",
                        "fieldDelimiter": "\t",
                        "object": "datax_dev/libin/e_coupon",
                        "writeMode": "truncate"
                    }
                }
        }
        ],
        "setting": {
            "speed": {
                "channel": 1
            }
        }
    }
}
```

触发执行 :

```python
python datax.py mysql2oss-e_coupon.json
```

## 2. ext table

创建外部表，ext_dm_e_coupon，并将 location 指向为 oss

```sql
DROP EXTERNAL TABLE PUBLIC.ext_dm_e_coupon;
CREATE EXTERNAL TABLE PUBLIC.ext_dm_e_coupon (
    id bigint,
    x_card_user_id varchar,
    coupon_discount_code varchar,
    ...
    order_merchant_id bigint
) LOCATION(
    'oss://oss-cn-hangzhou.aliyuncs.com
        dir=datax_dev/libin/
        id=xx
        key=xx
        bucket=xkeshi-data'
) FORMAT 'text' (NULL AS 'null');


-- 45596 id comment 字段有回车 ,So del comment varchar, don't imported.
```

## 3. ods table

创建 ods\_dm\_e\_coupon 表，并向其中导入数据

```sql
DROP TABLE ods_dm_e_coupon;
CREATE TABLE ods_dm_e_coupon AS SELECT
	*
FROM
	ext_dm_e_coupon distributed BY (id);
```

> 注意 : 这样建表 ods table id，不是 primary key

> 显示指定 distributed BY (id)，可读性更好

## 4. mds table

创建 mds\_dm\_e\_coupon\_profile 表

```sql
DROP TABLE mds_dm_e_coupon_profile;

CREATE TABLE mds_dm_e_coupon_profile (
	id bigserial,
	coupon_info_code VARCHAR,
	shop_id BIGINT,
	collected_avg_actual_price DECIMAL (12, 2),
	collected_sum_actual_price DECIMAL (12, 2),
	collected_count INT,
	verified_count INT,
	verified_rate DECIMAL (12, 2)
) WITH (
	appendonly = TRUE,
	compresslevel = 5
) distributed BY (id);
```

> 创建表的时候，给一个自增 id. 每一个表都有一个自增 id，是一个比较好的规范

## 5. insert mds table

insert data to mds\_dm\_e\_coupon\_profile

```sql
INSERT INTO mds_dm_e_coupon_profile (
	coupon_info_code,
	shop_id,
	collected_avg_actual_price,
	collected_sum_actual_price,
	collected_count,
	verified_count,
	verified_rate
) SELECT
	tt1.coupon_info_code,
	tt1.shop_id,
	tt1.avg_actual_price AS collected_avg_actual_price,
	tt1.sum_actual_price AS collected_sum_actual_price,
	tt1.collected_count,
	COALESCE (tt2.verified_count, 0) AS verified_count,
	round(
		(
			COALESCE (tt2.verified_count, 0) * 1.0
		) / (tt1.collected_count * 1.0),
		2
	) AS verified_rate
FROM
	(
		SELECT
			t1.coupon_info_code,
			t1.shop_id,
			COUNT (t1.ID) AS collected_count,
			round(AVG(t1.actual_price), 2) AS avg_actual_price,
			SUM (t1.actual_price) AS sum_actual_price
		FROM
			(
				SELECT
					*
				FROM
					ods_dm_e_coupon
				WHERE
					status = 1
			) t1
		GROUP BY
			(t1.coupon_info_code, t1.shop_id)
		ORDER BY
			t1.shop_id
	) tt1
LEFT JOIN (
	SELECT
		t2.coupon_info_code,
		t2.shop_id,
		COUNT (t2.ID) AS verified_count,
		round(AVG(t2.actual_price), 2) AS avg_actual_price,
		SUM (t2.actual_price) AS sum_actual_price
	FROM
		(
			SELECT
				*
			FROM
				ods_dm_e_coupon
			WHERE
				status = 1
			AND RESULT = 2
		) t2
	GROUP BY
		(t2.coupon_info_code, t2.shop_id)
	ORDER BY
		t2.shop_id
) tt2 ON tt1.coupon_info_code = tt2.coupon_info_code
AND tt1.shop_id = tt2.shop_id
```

## 6. validation results

```sql
select * from mds_dm_e_coupon_profile order by id limit 20;
```

<!--![][2]-->

[1]: /images/ops/greenplum-flow.png
[2]: /images/ops/greenplum-man-1.png
