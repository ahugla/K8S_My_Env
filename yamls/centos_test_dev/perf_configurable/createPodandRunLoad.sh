#
#  USAGE:
#  ./script.sh [CPU LIMIT en m]  [MEM LIMIT en Mi]  [duree du stress en sec]
#  ./script.sh  1000  2000 3600  (limite du pod a: 1 CPU et 2 Go RAM et stress pendant 3600sec)
#
#


# prepare fichiers
rm -f yaml2run.yaml
cp template.yaml yaml2run.yaml


# INFO POD ET STRESS
LIMITCPU=$1m
LIMITMEMORY=$2Mi
STRESSDURATION=$3s
echo "Limit CPU du pod: " $LIMITCPU
echo "Limit MEMOIRE du pod: " $LIMITMEMORY
echo "Stress pendant $STRESSDURATION"

# Update du fichier yaml avec les limites cpu et memoire
sed -i -e 's/$${LIMITCPU}/'"$LIMITCPU"'/g'  yaml2run.yaml
sed -i -e 's/$${LIMITMEMORY}/'"$LIMITMEMORY"'/g'  yaml2run.yaml


# Creation du pod
ligne=`kubectl create -f yaml2run.yaml`


# identification du pod créé
podname=`echo $ligne"" | awk -F/ '{print $2}' | awk -F" " '{print $1}'`
echo "pod = " $podname
nodename=`kubectl get pods -o wide | grep $podname | awk -F" " '{print $7}'`
echo "node = " $nodename


# calcul du nombre de process de stress pour la memoire (on ne peut pas depasser, on n'a pas ce pb avec le cpu)
nbre=$(echo "$2/128" |bc )
echo "Nombre de worker de stress memoire: "$nbre


# on attend que le pod soit ready puis on execute la commande pour charger le pod
sleep 3
commandline="stress --cpu 8 --io 4  --vm $nbre  --vm-bytes 128M --timeout $STRESSDURATION"
kubectl exec -it $podname -- /bin/bash -c "$commandline"


# Exemple de commande passée
#kubectl exec -it centos-perf-ctbnl -- /bin/bash -c "stress --cpu 8 --io 4  --vm 4  --vm-bytes 128M --timeout 50s"



