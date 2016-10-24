#!/bin/bash
###############################################################################
#                                                                             
# @date:   2016.10.14
# @desc:   pandian kettle run com_shop_vip.ktr
#                                                                            
############################################################################### 

cd `dirname $0`/.. && wk_dir=`pwd` && cd -
source ${wk_dir}/util/env

echo_ex "${data_integration}/pan.sh -file=${data_dir}/com_shop_vip.ktr"

${data_integration}/pan.sh -file=${data_dir}/com_shop_vip.ktr

check_success

exit 0
