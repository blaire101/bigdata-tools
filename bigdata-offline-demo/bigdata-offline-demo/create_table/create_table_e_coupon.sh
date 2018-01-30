#!/bin/sh
cd `dirname $0`/.. && wk_dir=`pwd` && cd -
source ${wk_dir}/util/env

###### create ods_dm_e_coupon ##########
table_name="${table_ods_e_coupon}"
hql="create external table if not exists ${table_name}
(
    id bigint COMMENT '序号',
    x_card_user_id varchar(50) COMMENT 'x卡的用户id',
    coupon_discount_code varchar(50) COMMENT '电子券核销码',
    coupon_verify_code varchar(50) COMMENT '电子券核销单号',
    mobile_number varchar(16) COMMENT '领取电子券的手机号',
    coupon_order_number varchar(32) COMMENT '购买电子券时的订单编号',
    order_type tinyint COMMENT '1、卡券，2、活动',
    coupon_info_code varchar(25) COMMENT '电子券编码',
    coupon_info_name varchar(20) COMMENT '电子券名称',
    coupon_info_channel_id bigint,
    coupon_info_channel_detail_id bigint COMMENT '关联渠道详情表id',
    wemall_sale_id bigint COMMENT 'wemall上架的ID',
    wemall_id bigint COMMENT 'WemallID',
    coupon_category_id tinyint COMMENT '种类：1凭证券,2代金券,3满减券,4折扣券,5运费券,6买赠券',
    general tinyint COMMENT '是否通用券,0:否,1:是',
    actual_price decimal(12,2) COMMENT '实际支付金额',
    server_fee decimal(12,2) COMMENT '服务费',
    price decimal(12,2) COMMENT '售价',
    exchange_type tinyint COMMENT '0.人民币1.积分',
    denomination decimal(12,2) COMMENT '面额',
    exchange_price decimal(10,0) COMMENT '积分兑换',
    shop_id bigint COMMENT '核销操作员所属shop编号',
    shop_name varchar(100) COMMENT '核销操作员所属shop名称',
    operator_name varchar(60) COMMENT '核销电子券的操作员',
    operator_id bigint COMMENT '操作员编号',
    result tinyint COMMENT '状态，0:未开始,1:未核销，2:核销成功，3:退款中,4:已退款，5:已过期,6:已冻结,7:退款失败',
    verify_time timestamp COMMENT '核销时间',
    refund_apply_time timestamp COMMENT '退款申请时间',
    refund_time timestamp COMMENT '退款时间',
    refund_reason varchar(500),
    refund_order_number varchar(45) COMMENT '退款订单号',
    enable_refund tinyint COMMENT '是否支持退款:1支持，0不支持',
    refund_url varchar(255),
    get_channel tinyint COMMENT '电子券获取渠道',
    get_channel_detail int COMMENT '电子券来源详情，get_channel为“促销工具”时用于描述详情',
    valid_time timestamp COMMENT '电子券生效时间',
    expire_time timestamp COMMENT '电子券失效时间',
    created_time timestamp COMMENT '创建时间',
    updated_time timestamp COMMENT '更新时间',
    payment_type tinyint COMMENT '支付渠道 0_支付宝，1_微信公众号支付，2_短信赠送，3_免费领取，4_银联支付，5_杭州银行e支付，6_积分兑换，7_杭州银行活动领取，8_预付卡，9_三方平台领取,10微信APP支付,11翼支付,12中国工商银行支付',
    payment_type_str varchar(255) COMMENT '对应支付系统的支付方式 - 订单重构以后都使用此字段做为支付方式',
    accept_business_id bigint COMMENT '收款商户id',
    accept_business_type varchar(10) COMMENT '收款商户类型',
    accept_business_name varchar(255) COMMENT '收款商户名称',
    status tinyint COMMENT '有效状态(1,有效 0,无效)',
    comment varchar(255) COMMENT '备注',
    order_shop_id bigint COMMENT '购买电子券的商户id',
    order_merchant_id bigint COMMENT '购买电子券的集团id',
    client_code tinyint COMMENT '核销渠道(1,门店通2,收银台3,核销客户端4,营销客户端5,网页核销客户端6,openApi7,庙街8,轻盈核销9口碑)',
    lock_order_number varchar(40) COMMENT '锁定电子券的订单号'
) COMMENT '实际电子券'
partitioned by (dt string)
row format delimited fields terminated by '\001' collection items terminated by ',' map keys terminated by ':' lines terminated by '\n'
stored as rcfile
location '${OSS_URL}/${ods_hive_dir}/${table_name}';
"
echo "$hql"
${HIVE} -e "$hql"
###### create tmp_ods_dm_e_coupon ##########
table_name="${table_tmp_ods_e_coupon}"
hql="create external table if not exists ${table_name}
(
    id bigint COMMENT '序号',
    x_card_user_id varchar(50) COMMENT 'x卡的用户id',
    coupon_discount_code varchar(50) COMMENT '电子券核销码',
    coupon_verify_code varchar(50) COMMENT '电子券核销单号',
    mobile_number varchar(16) COMMENT '领取电子券的手机号',
    coupon_order_number varchar(32) COMMENT '购买电子券时的订单编号',
    order_type tinyint COMMENT '1、卡券，2、活动',
    coupon_info_code varchar(25) COMMENT '电子券编码',
    coupon_info_name varchar(20) COMMENT '电子券名称',
    coupon_info_channel_id bigint,
    coupon_info_channel_detail_id bigint COMMENT '关联渠道详情表id',
    wemall_sale_id bigint COMMENT 'wemall上架的ID',
    wemall_id bigint COMMENT 'WemallID',
    coupon_category_id tinyint COMMENT '种类：1凭证券,2代金券,3满减券,4折扣券,5运费券,6买赠券',
    general tinyint COMMENT '是否通用券,0:否,1:是',
    actual_price decimal(12,2) COMMENT '实际支付金额',
    server_fee decimal(12,2) COMMENT '服务费',
    price decimal(12,2) COMMENT '售价',
    exchange_type tinyint COMMENT '0.人民币1.积分',
    denomination decimal(12,2) COMMENT '面额',
    exchange_price decimal(10,0) COMMENT '积分兑换',
    shop_id bigint COMMENT '核销操作员所属shop编号',
    shop_name varchar(100) COMMENT '核销操作员所属shop名称',
    operator_name varchar(60) COMMENT '核销电子券的操作员',
    operator_id bigint COMMENT '操作员编号',
    result tinyint COMMENT '状态，0:未开始,1:未核销，2:核销成功，3:退款中,4:已退款，5:已过期,6:已冻结,7:退款失败',
    verify_time timestamp COMMENT '核销时间',
    refund_apply_time timestamp COMMENT '退款申请时间',
    refund_time timestamp COMMENT '退款时间',
    refund_reason varchar(500),
    refund_order_number varchar(45) COMMENT '退款订单号',
    enable_refund tinyint COMMENT '是否支持退款:1支持，0不支持',
    refund_url varchar(255),
    get_channel tinyint COMMENT '电子券获取渠道',
    get_channel_detail int COMMENT '电子券来源详情，get_channel为“促销工具”时用于描述详情',
    valid_time timestamp COMMENT '电子券生效时间',
    expire_time timestamp COMMENT '电子券失效时间',
    created_time timestamp COMMENT '创建时间',
    updated_time timestamp COMMENT '更新时间',
    payment_type tinyint COMMENT '支付渠道 0_支付宝，1_微信公众号支付，2_短信赠送，3_免费领取，4_银联支付，5_杭州银行e支付，6_积分兑换，7_杭州银行活动领取，8_预付卡，9_三方平台领取,10微信APP支付,11翼支付,12中国工商银行支付',
    payment_type_str varchar(255) COMMENT '对应支付系统的支付方式 - 订单重构以后都使用此字段做为支付方式',
    accept_business_id bigint COMMENT '收款商户id',
    accept_business_type varchar(10) COMMENT '收款商户类型',
    accept_business_name varchar(255) COMMENT '收款商户名称',
    status tinyint COMMENT '有效状态(1,有效 0,无效)',
    comment varchar(255) COMMENT '备注',
    order_shop_id bigint COMMENT '购买电子券的商户id',
    order_merchant_id bigint COMMENT '购买电子券的集团id',
    client_code tinyint COMMENT '核销渠道(1,门店通2,收银台3,核销客户端4,营销客户端5,网页核销客户端6,openApi7,庙街8,轻盈核销9口碑)',
    lock_order_number varchar(40) COMMENT '锁定电子券的订单号',
    dt string
) COMMENT '实际电子券'
row format delimited fields terminated by '\001' collection items terminated by ',' map keys terminated by ':' lines terminated by '\n'
stored as textfile
location '${OSS_URL}/${tmp_hive_dir}/${table_name}';
"
echo "$hql"
${HIVE} -e "$hql"
