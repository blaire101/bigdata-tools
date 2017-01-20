#!/bin/bash
###############################################################################
#                                                                             
# @date:   2017.01.19
# @desc:   ext e_coupon -> ods e_coupon
#                                                                            
############################################################################### 

cd `dirname $0`/.. && wk_dir=`pwd` && cd -
source ${wk_dir}/util/env

echo_ex "${datax_home}/bin/datax.py -p \"-Dbegin_time='2010-01-01' -Dend_time='${d1}' -Dgpextdata='${gpextdata}'\" ${data_dir}/xkeshi_com.ext/mysql2textfile-e_coupon.json"

python ${datax_home}/bin/datax.py -p "-Dbegin_time='2010-01-01' -Dend_time='${d1}' -Dgpextdata='${gpextdata}'" ${data_dir}/xkeshi_com.ext/mysql2textfile-e_coupon.json
check_success

echo_ex "${data_integration}/kitchen.sh -file=${ktrs_dir}/ods_e_coupon.kjb"

${data_integration}/kitchen.sh -file=${ktrs_dir}/ods_e_coupon.kjb
check_success

echo_ex "import e_coupon end"

exit 0
