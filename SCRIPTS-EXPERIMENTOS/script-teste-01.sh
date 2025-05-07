#!/bin/bash

# Especificando a namespace
namespace="vote"

# Coletando informações dos pods
pods=$(kubectl get pods -n $namespace | awk '{if(NR>1)print $1}')

# Loop para percorrer cada pod
for pod in $pods; do

	#for i in {1..1}
	 #do
	   sleep $(echo $((RANDOM % 7 + 2)) | awk '{print int($1)}')
	   kubectl exec -it $pod -n $namespace -- time ping -4 -c 2 8.8.8.8 > execution.txt
	   readarray TEMPO_EXECUCAO < execution.txt
	   TEMPO_REAL=$(kubectl exec -it $pod -n $namespace -- time ping -4 -c 2 8.8.8.8 | grep real)
	   TEMPO_USUARIO=$(kubectl exec -it $pod -n $namespace -- time ping -4 -c 2 8.8.8.8 | grep user)
	   TEMPO_SISTEMA=$(kubectl exec -it $pod -n $namespace -- time ping -4 -c 2 8.8.8.8 | grep sys)
	   BLOCKED=$(kubectl describe pods $pod -n $namespace | grep 'blocked')
	echo $TEMPO_EXECUCAO
	echo $TEMPO_REAL
	echo $TEMPO_USUARIO
	echo $TEMPO_SISTEMA

	  #  if [ $? -eq 0 ]
	 #    then
	#	 BLOCKED="sim"
	 #   else
	#	 BLOCKED="não"
	  #  fi
  #echo "$i, $TEMPO_EXECUCAO, $TEMPO_REAL, $TEMPO_USUARIO, $TEMPO_SISTEMA, $BLOCKED" >> /home/jonathan/teste_resultado.txt
#	done
done
