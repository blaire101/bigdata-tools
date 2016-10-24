#!/bin/bash
###############################################################################
#                                                                             
# @date:   2016.10.14
#                                                                            
############################################################################### 

cd `dirname $0`/.. && wk_dir=`pwd` && cd -
source ${wk_dir}/util/crontab_job_env

log_uri=${log_dir}/${job_name}.log.${d1}
echo "$log_uri"
exec 1>>${log_uri} 2>&1

echo "##################################################"
echo "[INFO] date:${d1}"
echo "[INFO] time:" `date`
echo "[INFO] job_name: ${job_name}"
flag_self_dir=${flag_dir}/dw_pd_itemquantity_m_kjb

#check crontab_label whether exist
if check_local_crontab_label ${flag_self_dir} ${d1}
  then
    echo "[INFO] script already run!"
else
  echo "[INFO] check dependention"
  check_local_all_done ${flag_dir}/com_check_order_detail_ktr ${d1} || exit 255
  check_local_all_done ${flag_dir}/com_check_order_ktr ${d1} || exit 255
  check_local_all_done ${flag_dir}/com_shop_vip_ktr ${d1} || exit 255
  
  echo "[INFO] script run!"

# generate crontab_label
  touch_local_crontab_label ${flag_self_dir} ${d1}
#sleep 
  sleep 10
# run main script
  echo "[INFO] start run..."

  sh dw_pd_itemquantity_m_kjb.sh ${d1}

  if [ $? -eq 0 ] ; then
    touch_local_all_done ${flag_self_dir} ${d1}
  else
    alert "$job_name" "failure-$d1" "${log_uri}"
  fi
fi
echo_ex "run $0 end!"
