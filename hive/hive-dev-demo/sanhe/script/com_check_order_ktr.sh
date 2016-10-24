#!/bin/bash
###############################################################################
#                                                                             
# @date:   2016.10.14
# @desc:   pandian kettle com_check_order.ktr
#                                                                            
############################################################################### 

cd `dirname $0`/.. && wk_dir=`pwd` && cd -
source ${wk_dir}/util/env

echo_ex "${data_integration}/pan.sh -file=${data_dir}/com_check_order.ktr"

${data_integration}/pan.sh -file=${data_dir}/com_check_order.ktr

check_success

exit 0
