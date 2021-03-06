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
#Exemplo:
#
#      Access the director AppTest/debian
#      Execute command:
#      1 - kubectl create -f namespaces/
#      2 - kubectl create -f services/
#      3 - kubectl create -f deployements/
#      After the command, return for / with command ../..
#      Execute the script sarik.sh
#
#--------------------------------------------------------------------------------------#
#Histórico
#
#  v1.0 03/12/2021, Jonathan G.P. dos Santos
#      - Beta.
#  V1.01 02/01/2022, Jonathan G.P. dos Santos
#      - until, loop for configuration iptables 
#      - variables
#  V1.02 04/01/2022, Jonathan G.P. dos Santos
#      - Add While and code tweaks
#      - Variables IP, PORT etc
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

kubectl get pod -n "$VALUE_NAMESPACE" -o wide | awk '{print $6}' | grep -v ^IP | sed 's/0.*.//' > IP_NETWORK #armazena a lista de IP

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

#---------------------------------TESTES-----------------------------------------------#
#Docker install?
[ ! -x "$(which docker)" ] && printf "Precisa instalar o docker, por favor, instale.\n" && exit 1
#minikube install?
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
until [ $CONT -le 0 ]
do
      echo "Faltam $CONT replicas para configurar firewall."
      VERSION_OS=`kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- grep ^NAME=.*$ /etc/os-release | awk '{print $1}' | sed s/NAME="."//`
      echo "============================="
      echo "O sistema operacional do POD é: $(echo -e ${VERMELHO} $VERSION_OS) $(echo -e ${BRANCO})" #Version the of sistym operation
      sleep 2
      echo "O namespace da rede é: $(echo -e ${VERMELHO} $VALUE_NAMESPACE) $(echo -e ${BRANCO})" #Version the of namespace
      sleep 1
      echo "O nome do POD a ser configurado é: $(echo -e ${VERMELHO} ${POD_NAMESPACE[$CONT3]}) $(echo -e ${BRANCO})" #Version the of PODs, container
      sleep 2
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
    kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- apt update
    kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- apt install iptables -y

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
    kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- apt update 
    kubectl exec -n $VALUE_NAMESPACE ${POD_NAMESPACE[$CONT3]} -- apt install iptables -y
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
clear
echo " "
echo $(echo -e ${VERDE}) "System configuration done!!" $(echo -e ${BRANCO})
echo " "
cat << "EOF"
   _____              _____    _____   _  __
  / ____|     /\     |  __ \  |_   _| | |/ /
 | (___      /  \    | |__) |   | |   | ' /
  \___ \    / /\ \   |  _  /    | |   |  <
  ____) |  / ____ \  | | \ \   _| |_  | . \
 |_____/  /_/    \_\ |_|  \_\ |_____| |_|\_\

EOF
echo " "
echo "==================================================================================="
echo "=========== AUTOMATIC SECURITY OF RULES ON IPTABLES IN KUBERNETES ================="
echo "===========           By @jonathamgg and @jonathan | DC           ================="
echo "==================================================================================="
#
#--------------------------------------------------------------------------------------#
