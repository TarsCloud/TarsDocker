

user="tars-test"
NS=`helm list --namespace ${user} | grep ${user} | awk '{print $1}'`
echo $NS, $user

if [ "$NS" == "" ]; then
    echo "create tars-k8s"
    kubectl create namespace $user
    helm install $user ./stable/tars --namespace $user --set tarsnode.replicas=1,tars.namespace=$user
else
    echo "upgrade tars-k8s"
    helm upgrade $user ./stable/tars --namespace $user

fi
