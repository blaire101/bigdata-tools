#!/bin/bash
###############################################################################
#                                                                             
# @date:   2016.03.15
# @desc:   ods_dm_shop
# partition dt 为每天刷全表的数据
#                                                                            
############################################################################### 
cd `dirname $0`/.. && wk_dir=`pwd` && cd -
source ${wk_dir}/util/env
source ${util_dir}/my_functions
# 38 item in shop table
exec_sql="
  SELECT
    shop.id,shop.category_id,shop.region_id,shop.cityCode,shop.merchant_id,
    shop.balance_id,shop.balance,shop.address,shop.contact,shop.domain,
    shop.shopHours,shop.banner_id,shop.avatar_id,shop.name,shop.fullName,
    shop.visible,shop.brand_id,shop.wechat,shop.weibo,shop.stars,
    shop.tag,shop.position_id,shop.printer_enable,shop.printer_ip,shop.printer_port,
    shop.enable_shift,shop.visible_shift_receivable_data,shop.enable_multiple_payment,shop.statisticsDate,shop.createDate,
    shop.modifyDate,shop.deleted,shop.need_sy,shop.sy_start_time,shop.sy_end_time,
    shop.slogans,shop.distribution,shop.signboards_id
  FROM
    shop 
  WHERE 
    id in (SELECT businessId from account where nature='FORMAL' and businessType='SHOP')
    AND DATE_FORMAT(createDate, '%Y-%m-%d')<='$d1'
    AND deleted <> 1
    AND \$CONDITIONS"

if [ -n "${table_ods_shop_tmp}" ] && [ ${table_ods_shop_tmp} != "/" ]; then
  target_dir="${tmp_hive_dir}${table_ods_shop_tmp}"
else
  exit 255
fi

import_data_hdfs "${exec_sql}" "${target_dir}" "${jdbc_url_rds1}" "${jdbc_username_rds1}" "${jdbc_passwd_rds1}" "shop.id"
check_success

hql="insert overwrite table ${table_ods_shop} partition(dt='$d1')
    select * from ${table_ods_shop_tmp}"

echo_ex "${hql}"
${HIVE} -e "${hql}"

check_success
exit 0
