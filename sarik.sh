#!/usr/bin/env bash
#
#  SARIK - SEGURANÇA AUTOMÁTICA DE REGRAS EM IPTABLES EM KUBERNETES
#
#  SITE:          https://sarik.org
#  Autor:         Jonathan G.P. dos Santos
#  Manutenção:    Jonathan G.P. dos Santos#
#
#--------------------------------------------------------------------------------------#
#Exemplo:
#
#
#
#--------------------------------------------------------------------------------------#
#Histórico
#
#  v1.0 03/12/2021, Jonathan G.P. dos Santos
#      - Beta.
#  
#
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
#   Dr. Geraldo Pereira Rocha Filho - Co-Orientador do projeto
#
#
#--------------------------------------------------------------------------------------#

echo " "
cat << "EOF"
   _____              _____    _____   _  __
  / ____|     /\     |  __ \  |_   _| | |/ /
 | (___      /  \    | |__) |   | |   | ' /
  \___ \    / /\ \   |  _  /    | |   |  <
  ____) |  / ____ \  | | \ \   _| |_  | . \
 |_____/  /_/    \_\ |_|  \_\ |_____| |_|\_\

EOF
echo "=========================================================="
echo "================== AUTOMATIC SECURITY OF RULES ON IPTABLES IN KUBERNETES ================="
echo "=========== By @jonathamgg and @jonathan | DC =========="
echo "=========================================================="
echo " "
echo " "



#---------------------------------VARIÁVEIS--------------------------------------------#
#
NODES=`kubectl get node | awk '{print $1}' | grep -v ^N` #store nodes
#for i in "${NODES[@]}";do echo "NODE : $i";done
POD=`kubectl get pod | awk '{print $1}' | grep -v ^N` #store pod
#for i in "${POD[@]}";do echo "POD : $i";done
LISTNAMES=`kubectl get namespace | awk '{print $1}' | grep -v ^'default' | grep -v ^N | grep -v ^kube`
for i in "${LISTNAMES[@]}";do echo "$i";done
#
#--------------------------------------------------------------------------------------#

#---------------------------------TESTES-----------------------------------------------#
#Docker instalado?
[ ! -x "$(which docker)" ] && printf "Precisa instalar o docker, por favor, instale.\n" && exit 1
#minikube instalado?
[ ! -x "$(which minikube)" ] && printf "Precisa instalar o minikube, por favor, instale.\n" && exit 1
#--------------------------------------------------------------------------------------#

#---------------------------------FUNÇÕES----------------------------------------------#
#
#
#--------------------------------------------------------------------------------------#

#---------------------------------EXECUÇÃO---------------------------------------------#
#
#
#--------------------------------------------------------------------------------------#
