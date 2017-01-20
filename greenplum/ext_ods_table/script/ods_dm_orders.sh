#!/bin/bash
###############################################################################
#                                                                             
# @date:   2017.01.19
# @desc:   ext orders -> ods orders
#                                                                            
############################################################################### 

cd `dirname $0`/.. && wk_dir=`pwd` && cd -
source ${wk_dir}/util/env

echo_ex "${datax_home}/bin/datax.py -p \"-Dbegin_time='${d1}' -Dend_time='${d1}' -Dgpextdata='${gpextdata}'\" ${data_dir}/xkeshi_com.ext/mysql2textfile-orders.json"

python ${datax_home}/bin/datax.py -p "-Dbegin_time='${d1}' -Dend_time='${d1}' -Dgpextdata='${gpextdata}'" ${data_dir}/xkeshi_com.ext/mysql2textfile-orders.json
check_success

echo_ex "${data_integration}/kitchen.sh -file=${ktrs_dir}/ods_orders.kjb"

${data_integration}/kitchen.sh -file=${ktrs_dir}/ods_orders.kjb
check_success

echo_ex "import orders end"

exit 0
