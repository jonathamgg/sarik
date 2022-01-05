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
sleep 2
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

echo "Agradecimentos aos professores:"
sleep 1
echo "Dr. Vinícius Pereira Gonçalves  - Orientador do projeto"
sleep 2
echo "Dr. Geraldo Pereira Rocha Filho - Co-Orientador do projeto"
sleep 2
echo " "
echo " "
#---------------------------------VARIÁVEIS--------------------------------------------#
#
NODES=`kubectl get node | awk '{print $1}' | grep -v ^NAME` #store nodes
#for i in "${NODES[@]}";do echo "NODE : $i";done

#POD=`kubectl get pod | awk '{print $1}' | grep -v ^NAME` #store pod
#for i in "${POD[@]}";do echo "POD : $i";done

VALUE_NAMESPACE=`kubectl get namespace | awk '{print $1}' | grep -v ^'default' | grep -v ^NAME | grep -v ^kube` #store name namespace
#for i in "${LISTNAMES[@]}";do echo "$i";done

kubectl get pod -n "$VALUE_NAMESPACE" | awk '{print $1}' | grep -v ^NAME > pod.txt #recebe a lista de pod e joga para o arquivo

readarray POD_NAMESPACE < pod.txt #armazena a lista de pod em um array

CONT=`kubectl get pod -n "$VALUE_NAMESPACE" | awk '{print $1}' | grep -v ^NAME | wc -l`
#for i in "${POD_NAMESPACE[@]}";do echo "$i";done

#Contadores
CONT2=6 #Cont progress-bar
CONT3=0 #Cont pod_namespace
#
#--------------------------------------------------------------------------------------#

#---------------------------------TESTES-----------------------------------------------#
#Docker instalado?
[ ! -x "$(which docker)" ] && printf "Precisa instalar o docker, por favor, instale.\n" && exit 1
#minikube instalado?
[ ! -x "$(which minikube)" ] || [ ! -x "$(which kubectl)" ] && printf "Precisa instalar o minikube ou kubectl, por favor, instale.\n" && exit 1
#--------------------------------------------------------------------------------------#

#---------------------------------FUNÇÕES----------------------------------------------#
#

#Progress-bar with problem
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
#Progress-bar ok
progress-bar2() {
[[ $# -ne 1 ]] && error 1
[[ $1 =~ ^[0-9]+$ ]] || error 2

duration=${1}
barsize=$((`tput cols` - 7))
unity=$(($barsize / $duration))
increment=$(($barsize%$duration))
skip=$(($duration/($duration-$increment)))
curr_bar=0
prev_bar=
for (( elapsed=1; elapsed<=$duration; elapsed++ ))
do
  # Elapsed
prev_bar=$curr_bar
  let curr_bar+=$unity
  [[ $increment -eq 0 ]] || {  
    [[ $skip -eq 1 ]] &&
      { [[ $(($elapsed%($duration/$increment))) -eq 0 ]] && let curr_bar++; } ||
    { [[ $(($elapsed%$skip)) -ne 0 ]] && let curr_bar++; }
  }
  [[ $elapsed -eq 1 && $increment -eq 1 && $skip -ne 1 ]] && let curr_bar++
  [[ $(($barsize-$curr_bar)) -eq 1 ]] && let curr_bar++
  [[ $curr_bar -lt $barsize ]] || curr_bar=$barsize
  for (( filled=0; filled<=$curr_bar; filled++ )); do
    printf "▇"
  done

  # Remaining
  for (( remain=$curr_bar; remain<$barsize; remain++ )); do
    printf " "
  done

  # Percentage
  printf "| %s%%" $(( ($elapsed*100)/$duration))

  # Return
  sleep 1
  printf "\r"
done
printf "\n"
}
#
#--------------------------------------------------------------------------------------#

#---------------------------------EXECUÇÃO---------------------------------------------#
#
sleep 5
until [ $CONT -le 1 ]
do
      CONTLINHAS=$CONT
      ((CONTLINHAS=CONTLINHAS-1))
      echo "Faltam $CONTLINHAS replicas para configurar firewall."
      VERSION_OS=`kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- grep ^NAME=.*$ /etc/os-release | awk '{print $1}' | sed s/NAME="."//`
      echo "$VERSION_OS" #Version the of sistym operation
      echo "$VALUE_NAMESPACE" #Version the of namespace
      echo "${POD_NAMESPACE[$CONT3]}" #Version the of PODs, container

    case $VERSION_OS in
    #O.S Alpine
    Alpine)
    #test touch in the POD
    kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- touch teste.txt
    kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- apk update 
    kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- apk add iptables

    CONT_LINE=`cat RuleSO/alpine.cf | wc -l`
    readarray OS < RuleSO/alpine.cf
    i=0
    	while [ $i -le $CONT_LINE ];do
	echo ${OS[${i}]}
	kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- echo "${OS[${i}]}" >> teste.txt
	((i=i+1))
	done
    ;;
    #O.S Debian
    Debian)
    #test touch in the POD
    kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- touch teste.txt
    kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- apt update && apt install iptables -y
    CONT_LINE=`cat RuleSO/debian.cf | wc -l`
    readarray OS < RuleSO/debian.cf
    i=0
        while [ $i -le $CONT_LINE ];do
        echo ${OS[${i}]}
        kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- echo "${OS[${i}]}" >> teste.txt
        ((i=i+1))
	done
    ;;
    #O.S Ubuntu
    Ubuntu)
    #test touch in the POD
    kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- touch teste.txt
    kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- apt update && apt install iptables -y
    CONT_LINE=`cat RuleSO/ubuntu.cf | wc -l`
    readarray OS < RuleSO/ubuntu.cf
    i=0
        while [ $i -le $CONT_LINE ];do
        echo ${OS[${i}]}
        kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- echo "${OS[${i}]}" >> teste.txt
    
        ((i=i+1))
        done
    esac
    progress-bar2 $CONT2
    ((CONT=CONT-1))
    ((CONT3=CONT3+1))
done
#
#--------------------------------------------------------------------------------------#
