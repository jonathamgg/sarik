#!/bin/bash

# Obtendo todos os pods no namespace vote
pods=$(kubectl get pods -n vote -o jsonpath='{.items[*].metadata.name}')

# Inicializar variáveis para contar comunicações bloqueadas, legítimas e maliciosas
blocked=0
legitimate=0
malicious=0

# Inicializar variáveis para contar comunicações com dados alterados
altered=0
total=0

# Inicializar variáveis para calcular o tempo de resposta
latency=0

# Loop através de cada pod
for pod in $pods; do
  # Obtenha as network policies aplicadas ao pod atual
  pod_policies=$(kubectl describe pod $pod -n vote | grep "Network Policies")

  # Verifica se há uma policy de bloqueio aplicada ao pod
  if [[ $pod_policies == *"block"* ]]; then
    blocked=$((blocked + 1))
 
  #Obtenha as informações de status do pod
  
  pod_status=$(kubectl get pod $pod -n vote -o jsonpath='{.status.phase}')
  
  #Verifica se o pod está em execução e se há alguma comunicação legítima
  if [ $pod_status == "Running" ] && [[ $pod_policies != "block" ]]; then
     legitimate=$((legitimate + 1))
  fi
  
  #Verifica se o pod está em execução e se há alguma comunicação maliciosa

if [ $pod_status == "Running" ] && [[ $pod_policies == "malicious" ]]; then
malicious=$((malicious + 1))
fi

#Verifica se o pod está em execução e se há alguma comunicação com dados alterados

if [ $pod_status == "Running" ] && [[ $pod_policies == "altered" ]]; then
altered=$((altered + 1))
fi

done

#Calcular a taxa de bloqueio

block_rate=$(echo "scale=2; $blocked / $total" | bc)

#Calcular a taxa de falsos positivos

false_positive_rate=$(echo "scale=2; $blocked / $legitimate" | bc)

#Calcular a taxa de detecção

detection_rate=$(echo "scale=2; $malicious / $total" | bc)

#Calcular a integridade

integrity=$(echo "scale=2; $altered / $total" | bc)

#Etapa de mostrar as métricas calculadas

echo "Taxa de bloqueio: $block_rate"
echo "Taxa de falso positivo: $false_positive_rate"
echo "Taxa de deteccao: $detection_rate"
echo "Integridade: $integrity"

# Criando o arquivo .CSV para armazenar os dados gerados pelo script

echo "Date, Taxa de bloqueio,Taxa de falso positivo,Taxa de deteccao,Integridade" > metricas_para_test_F_e_t.csv
echo "$(date), $block_rate,$false_positive_rate,$detection_rate,$integrity" >> metricas_para_test_F_e_t.csv

