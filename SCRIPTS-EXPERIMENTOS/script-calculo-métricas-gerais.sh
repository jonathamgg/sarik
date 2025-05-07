#!/bin/bash

# Obter todos os pods no namespace "vote"
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
  # Obtenha o número de comunicações bloqueadas para o pod atual
  pod_blocked=$(kubectl logs $pod -n vote | grep "communication blocked" | wc -l)

  # Obtenha o número de comunicações legítimas para o pod atual
  pod_legitimate=$(kubectl logs $pod -n vote | grep "legitimate communication" | wc -l)

  # Obtenha o número de comunicações maliciosas para o pod atual
  pod_malicious=$(kubectl logs $pod -n vote | grep "malicious communication" | wc -l)

  # Obtenha o número de comunicações com dados alterados para o pod atual
  pod_altered=$(kubectl logs $pod -n vote | grep "communication data altered" | wc -l)

  # Hora de inicio da comunicação
  start_time=$(date +%s.%N)

  # Processa a comunicação (exemplo)
  kubectl exec $pod -n vote -- some_command

  # Hora final da comunicação
  end_time=$(date +%s.%N)

  # Cálculo da latência
  pod_latency=$(echo "$end_time - $start_time" | bc)
  latency=$(echo "$latency + $pod_latency" | bc)

  # Adicione o número atual de comunicações bloqueadas, legítimas, maliciosas e com dados alterados para o contador geral
  blocked=$((blocked + pod_blocked))
  legitimate=$((legitimate + pod_legitimate))
  malicious=$((malicious + pod_malicious))
  altered=$((altered + pod_altered))
  total=$((total + pod_legitimate + pod_malicious))
done

#Calcular a taxa de bloqueio

block_rate=$(echo "scale=2; $blocked / $total" | bc)

#Calcular a taxa de falsos positivos

false_positive_rate=$(echo "scale=2; $blocked / $legitimate" | bc)

#Calcular a taxa de detecção

detection_rate=$(echo "scale=2; $malicious / $total" | bc)

#Calcular a integridade

integrity=$(echo "scale=2; $altered / $total" | bc)

#Calcular a latencia média

average_latency=$(echo "$latency / $total" | bc)

#Imprima as métricas calculadas

echo "Block rate: $block_rate"
echo "False positive rate: $false_positive_rate"
echo "Detection rate: $detection_rate"
echo "Integrity: $integrity"
echo "Average latency: $average_latency"
