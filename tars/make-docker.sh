
#!/bin/bash

cp -rf /usr/local/tars/cpp/deploy/web/sql/*.sql /usr/local/tars/cpp/deploy/framework/sql/
cp -rf /usr/local/tars/cpp/deploy/web/demo/sql/*.sql /usr/local/tars/cpp/deploy/framework/sql/
 
strip /usr/local/tars/cpp/deploy/framework/servers/tars*/bin/tars*

TARS=(tarsAdminRegistry tarslog tarsconfig tarsnode  tarsnotify  tarspatch  tarsproperty  tarsqueryproperty  tarsquerystat  tarsregistry  tarsstat) 

cd /usr/local/tars/cpp/deploy/framework/servers; 

for var in ${TARS[@]} 
  do tar czf ${var}.tgz ${var} 
done

mkdir -p /usr/local/tars/cpp/deploy/web/files/

cp -rf /usr/local/tars/cpp/deploy/framework/servers/*.tgz /usr/local/tars/cpp/deploy/web/files/
rm -rf /root/Tars
