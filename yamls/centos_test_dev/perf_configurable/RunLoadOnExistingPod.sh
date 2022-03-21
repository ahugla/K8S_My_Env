#
#  USAGE:
#  ./RunLoadOnExistingPod.sh  [POD NAME] [duree du stress en sec]
#  ./RunLoadOnExistingPod.sh  centos-perf-4jgxl   1000  2000 3600  (stress 'centos-perf-4jgxl' pendant 3600sec)
#
#


#Recherche du node
nodename=`kubectl get pods -o wide | grep $1 | awk -F" " '{print $7}'`


#Recherche des limites du pod
LIMITCPU=`kubectl get pods  centos-perf-4jgxl -o jsonpath='{.spec.containers[0].resources.limits.cpu}'`
LIMITMEMORY=`kubectl get pods  centos-perf-4jgxl -o jsonpath='{.spec.containers[0].resources.limits.memory}'`


# INFO POD ET STRESS
PODNAME=$1
STRESSDURATION=$2s
echo "POD: " $PODNAME
echo "LIMITCPU: " $LIMITCPU
echo "LIMITMEMORY: " $LIMITMEMORY
echo "Node: " $nodename
echo "Stress pendant $STRESSDURATION"


# calcul du nombre de process de stress pour la memoire (on ne peut pas depasser, on n'a pas ce pb avec le cpu)
LIMITMEMORY_INT=`echo "${LIMITMEMORY/Mi/}"`
nbre=$(echo "$LIMITMEMORY_INT/128" |bc )
echo "Nombre de worker de stress memoire (128M par worker): "$nbre


# Execution de la commande pour charger le pod
commandline="stress --cpu 8 --io 4  --vm $nbre  --vm-bytes 128M --timeout $STRESSDURATION"
nohup kubectl exec -it $PODNAME -- /bin/bash -c "$commandline"



