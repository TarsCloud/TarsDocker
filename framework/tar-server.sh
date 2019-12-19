#!/bin/bash

TARS=(tarsAdminRegistry tarslog tarsconfig tarsnode  tarsnotify  tarspatch  tarsproperty  tarsqueryproperty  tarsquerystat  tarsregistry  tarsstat) 

cd /usr/local/tars/cpp/deploy/framework/servers; 

for var in ${TARS[@]} 
  do tar czf ${var}.tgz ${var} 
done