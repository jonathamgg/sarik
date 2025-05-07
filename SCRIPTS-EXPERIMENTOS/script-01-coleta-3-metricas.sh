#!/bin/bash

# Especificando a namespace
namespace="vote"

# Coletando informações dos pods
pods=$(kubectl get pods -n $namespace | awk '{if(NR>1)print $1}')

# Loop para percorrer cada pod
for pod in $pods; do

	#for i in {1..1}
	 #do
	 #Coletando o número de tentativas de comunicação bloqueadas pelo sistema
	 
	 blocked_attempts=$(kubectl describe networkpolicy -n $namespace | grep -c "deny")
	 
	 #Coletando o número total de tentativas de comunicação
	 
	 total_attempts=$(kubectl describe networkpolicy -n $namespace | grep -c "podSelector")

	 #Calculando a taxa de bloqueio
	 
	 block_rate=$(echo "scale=2; $blocked_attempts / $total_attempts" | bc)
	 
	 #Coletando a utilização de recursos
	 
	 resource_usage=$(kubectl top pod -n $namespace)
	 
	 #Salvando as informações em um arquivo .csv

	 echo "block_attempts,total_attempts,block_rate,resource_usage" > metrics.csv

	 echo "$blocked_attempts,$total_attempts,$block_rate,$resource_usage" >> metrics.csv
#	done
done
