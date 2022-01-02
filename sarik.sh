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
#  V1.01 02/12/2022, Jonathan G.P. dos Santos
#      - until, loop for configuration iptables 
#      - variables
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
echo "==================================================================================="
echo "=========== AUTOMATIC SECURITY OF RULES ON IPTABLES IN KUBERNETES ================="
echo "===========           By @jonathamgg and @jonathan | DC           ================="
echo "==================================================================================="
echo " "
echo " "


#---------------------------------VARIÁVEIS--------------------------------------------#
#
NODES=`kubectl get node | awk '{print $1}' | grep -v ^NAME` #store nodes
#for i in "${NODES[@]}";do echo "NODE : $i";done

POD=`kubectl get pod | awk '{print $1}' | grep -v ^NAME` #store pod
#for i in "${POD[@]}";do echo "POD : $i";done

VALUE_NAMESPACE=`kubectl get namespace | awk '{print $1}' | grep -v ^'default' | grep -v ^NAME | grep -v ^kube` #store name namespace
#for i in "${LISTNAMES[@]}";do echo "$i";done

POD_NAMESPACE=`kubectl get pod -n "$VALUE_NAMESPACE" | awk '{print $1}' | grep -v ^NAME`

CONT=`kubectl get pod -n "$VALUE_NAMESPACE" | awk '{print $1}' | grep -v ^NAME | wc -l`
#for i in "${POD_NAMESPACE[@]}";do echo "$i";done
echo "$CONT"

PWD=`pwd`
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
progress-bar() {
  local duration=${1}

    already_done() { for ((done=0; done<$elapsed; done++)); do printf "▇"; done }
    remaining() { for ((remain=$elapsed; remain<$duration; remain++)); do printf " "; done }
    percentage() { printf "| %s%%" $(( (($elapsed)*100)/($duration)*100/100 )); }
    clean_line() { printf "\r"; }

  for (( elapsed=1; elapsed<=$duration; elapsed++ )); do
      already_done; remaining; percentage
      sleep 1
      clean_line
  done
  clean_line
}

#
#--------------------------------------------------------------------------------------#

#---------------------------------EXECUÇÃO---------------------------------------------#
#
CONT2=5
until [ $CONT -le 0 ]
do
    echo "Faltam $CONT replicas para configurar firewall."
    echo "Teste kubectl ....."
    progress-bar $CONT2
    ((CONT=CONT-1))
done
#
#--------------------------------------------------------------------------------------#
