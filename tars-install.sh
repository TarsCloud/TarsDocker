
#https://github.com/goharbor/harbor-helm/blob/master/docs/High%20Availability.md

#helm repo add harbor https://helm.goharbor.io

#helm fetch harbor/harbor --untar

user="tars-k8s"
NS=`helm list | grep ${user} | awk '{print $1}'`
echo $NS, $user

if [ "$NS" == "" ]; then
    echo "create tars-k8s"
    kubectl create namespace $user
    helm install --name $user  --namespace $user tars-chart --set tarsnode.replicas=3 --set tars.namespace $user
else
    echo "upgrade tars-k8s"
    helm upgrade $user tars-chart

fi

#helm install --namespace tars-k8s --name tars-k8s tars-chart --set tarsnode.replicas=3

#helm upgrade --set tarsadmin.version="$tars_admin_version" $user tars-admin-chart