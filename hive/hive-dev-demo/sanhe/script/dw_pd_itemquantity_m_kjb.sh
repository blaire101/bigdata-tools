#!/bin/bash
###############################################################################
#                                                                             
# @date:   2016.10.14
# @desc:   dw_pd_itemquantity_m.kjb depend 3 ktr and dw_pd_itemquantity_m.ktr
#                                                                            
############################################################################### 

cd `dirname $0`/.. && wk_dir=`pwd` && cd -
source ${wk_dir}/util/env

#`date +'%Y%m%d' -d -1day`

echo_ex "${data_integration}/kitchen.sh -file=${data_dir}/dw_pd_itemquantity_m.kjb -param:startdatetime=${d0}"

${data_integration}/kitchen.sh -file=${data_dir}/dw_pd_itemquantity_m.kjb -param:startdatetime=${d0}
# prev senctence is java app, is not shell cmd
check_success

exit 0
