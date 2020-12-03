#!/bin/bash


# DELETE ALL SERVICES IN NAMESPACE DEFAULT
svcToDelete=`kubectl get service -n default | awk {'print $1'}  | sed '/NAME/d' | sed '/kubernetes/d'`
if [ "$svcToDelete" == "" ]
then
  echo "Aucun Service"
else
  echo "Suppression des services " $svcToDelete
  kubectl delete service $svcToDelete --namespace=default
fi

# DELETE ALL DEPLOYMENT IN NAMESPACE DEFAULT
kubectl delete deployment --all --namespace=default

# DELETE ALL RC IN NAMESPACE DEFAULT
kubectl delete rc --all --namespace=default

# DELETE ALL RS IN NAMESPACE DEFAULT
kubectl delete rs --all --namespace=default

# DELETE ALL PODS IN NAMESPACE DEFAULT
kubectl delete pod --all --namespace=default




#sleep 10      # attend 10s
#kubectl delete pods tito-fe-rc-newversion-sb5xl   --grace-period=0 --force