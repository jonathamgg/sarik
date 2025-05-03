#!/usr/bin/env bash
#
#  SARIK - SEGURANÇA AUTOMÁTICA DE REGRAS EM IPTABLES EM KUBERNETES
#
#  SITE:          https://sarik.org
#  Autor:         Jonathan G.P. dos Santos
#  Manutenção:    Jonathan G.P. dos Santos
#
#
#--------------------------------------------------------------------------------------#
#Histórico
#
#  V1.05 05/10/2023, Jonathan G.P. dos Santos
#      - Add variables
#--------------------------------------------------------------------------------------#
#Testado em:
#  bash 5.0.17
#
#
#--------------------------------------------------------------------------------------#
#Agradecimentos:
#
#
#   Dr. Vinícius Pereira Gonçalves  - Orientador do projeto
#   Dr. Geraldo Pereira Rocha Filho - Coorientador do projeto
#
#
#--------------------------------------------------------------------------------------#
#---------------------------------VARIÁVEIS--------------------------------------------#
#
BRANCO="\033[37;00m"
VERDE="\033[32;1m"
VERMELHO="\033[31;1m"
NODES=`kubectl get node | awk '{print $1}' | grep -v ^NAME` #store nodes
#for i in "${NODES[@]}";do echo "NODE : $i";done

#POD=`kubectl get pod | awk '{print $1}' | grep -v ^NAME` #store pod
#for i in "${POD[@]}";do echo "POD : $i";done

VALUE_NAMESPACE=`kubectl get namespace | awk '{print $1}' | grep -v ^'default' | grep -v ^NAME | grep -v ^kube` #store name namespace
#for i in "${LISTNAMES[@]}";do echo "$i";done

kubectl get pod -n "$VALUE_NAMESPACE" | awk '{print $1}' | grep -v ^NAME > pod_txt #recebe a lista de pod e joga para o arquivo

readarray POD_NAMESPACE < pod_txt #armazena a lista de pod em um array

kubectl get pod -n "$VALUE_NAMESPACE" -o wide | awk '{print $6}' | grep -v ^IP > IP_NETWORK #armazena a lista de IP

readarray IP_NET < IP_NETWORK

kubectl get services -n "$VALUE_NAMESPACE" | awk '{print $5}' | grep -v ^PORT | cut -d / -f1 > PORT_NAMESPACE #armazena as PORTs

readarray PORT_NS < PORT_NAMESPACE

kubectl get services -n "$VALUE_NAMESPACE" | awk '{print $5}' | grep -v ^PORT | cut -d / -f2 > PROTOCOL_NAMESPACE #armazena os procolos

readarray PROTOCOL_NS < PROTOCOL_NAMESPACE

CONT=`kubectl get pod -n "$VALUE_NAMESPACE" | awk '{print $1}' | grep -v ^NAME | wc -l`

#for i in "${POD_NAMESPACE[@]}";do echo "$i";done

#Contadores
CONT2=6 #Cont progress-bar
CONT3=0 #Cont pod_namespace
#
#--------------------------------------------------------------------------------------#