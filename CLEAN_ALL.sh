#!/bin/bash

# DELETE ALL DEPLOYMENT IN NAMESPACE DEFAULT
kubectl delete deployment --all --namespace=default

# DELETE ALL RC IN NAMESPACE DEFAULT
kubectl delete rc --all --namespace=default

# DELETE ALL RS IN NAMESPACE DEFAULT
kubectl delete rs --all --namespace=default

# DELETE ALL PODS IN NAMESPACE DEFAULT
kubectl delete pod --all --namespace=default

# DELETE ALL SERVICES IN NAMESPACE DEFAULT
svcToDelete=`kubectl get service | awk {'print $1'}  | sed '/NAME/d' | sed '/kubernetes/d'`
kubectl delete service $svcToDelete --namespace=default

