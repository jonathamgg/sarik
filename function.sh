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
#      - Add function
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

# Função para criar regra de bloqueio na interface de saída
create_block_rule() {
  local pod=$1
  local namespace=$2
  local protocol=$3
  local port=$4

  cat > "block-$pod-$port.yaml" <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-$port-$pod
  namespace: $namespace
spec:
  podSelector:
    matchLabels:
      app: $(echo $pod | cut -d'-' -f1)
  policyTypes:
  - Egress
  egress:
  - ports:
    - protocol: $protocol
      port: $port
  - to:
    - podSelector:
        matchLabels:
          app: $(echo $pod | cut -d'-' -f1)
EOF
}

# Função para criar regra de bloqueio na interface de entrada
create_ingress_block_rule() {
  local pod=$1
  local namespace=$2
  local port=$3
  local protocol=$4

  # Criar o arquivo YAML para a política de rede
  cat > ingress-block-$pod-$port.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-$port-ingress-$pod
  namespace: $namespace
spec:
  podSelector:
    matchLabels:
      app: $(echo $pod | cut -d'-' -f1)
  policyTypes:
  - Ingress
  ingress:
  - ports:
    - protocol: $protocol
      port: $port
  - to:
    - podSelector:
        matchLabels:
          app: $(echo $pod | cut -d'-' -f1)
EOF
}

# Função para excluir regra de bloqueio
delete_block_rule() {
  local policy_name=$1
  local namespace=$2

  # Excluir a política de rede
  kubectl delete networkpolicy $policy_name -n $namespace
}

# Função para monitorar políticas de rede
monitor_policies() {
  echo "Monitorando políticas de rede..."
  sleep 2
  # Listar todas as namespaces
  namespaces=$(kubectl get namespaces --no-headers -o custom-columns=":metadata.name")
  
  echo "Escolha uma namespace para monitorar as políticas de rede:"
  
  select ns in $namespaces; do
    if [ -n "$ns" ]; then
      echo "Você selecionou a namespace $ns."
      
      # Verificar se existem políticas de rede na namespace selecionada
      policies=$(kubectl get networkpolicy -n $ns --no-headers -o custom-columns=":metadata.name")
      
      if [ -z "$policies" ]; then
        echo "Não há políticas de rede para a namespace $ns."
      else
        echo "Políticas de rede na namespace $ns:"
        echo "$policies"
        
        # Detalhes adicionais sobre cada política
        for policy in $policies; do
          echo "Detalhes da política $policy:"
          kubectl describe networkpolicy $policy -n $ns
        done
      fi      
      break
    else
      echo "Seleção inválida. Tente novamente."
    fi
  done
}

# Função para fazer backup das políticas de rede
backup_policies() {
  echo "Realizando backup das políticas de rede..."
  sleep 3
  # Checa se o diretório backup_policies existe
  if [ -d "backup_policies" ]; then
    #Deletetando arquivos existentes no diretório
    rm -R backup_policies/* 2>/dev/null
  else
    #criando o diretório
    mkdir backup_policies
  fi
  
  # Listar todas as namespaces
  namespaces=$(kubectl get namespaces --no-headers -o custom-columns=":metadata.name")
  
  echo "Escolha uma namespace para fazer backup das políticas de rede:"
  
  select ns in $namespaces; do
    if [ -n "$ns" ]; then
      echo "Você selecionou a namespace $ns."
      
      # Verificar se existem políticas de rede na namespace selecionada
      policies=$(kubectl get networkpolicy -n $ns --no-headers -o custom-columns=":metadata.name")
      
      if [ -z "$policies" ]; then
        echo "Não há políticas de rede para a namespace $ns."
      else
        echo "Fazendo backup das políticas de rede na namespace $ns..."
        
        # Fazer backup de cada política
        for policy in $policies; do
          kubectl get networkpolicy $policy -n $ns -o yaml > backup_policies/$policy.yaml
        done
        
        echo "Backup concluído. Os arquivos foram salvos no diretório 'backup_policies'."
      fi
      
      break
    else
      echo "Seleção inválida. Tente novamente."
    fi
  done
}

# Função para validar políticas de rede
validate_policies() {
  echo "Validando políticas de rede..."
  sleep 3
  # Listar todas as namespaces
  namespaces=$(kubectl get namespaces --no-headers -o custom-columns=":metadata.name")

  echo "Escolha uma namespace para validar as políticas de rede:"

  select ns in $namespaces; do
    if [ -n "$ns" ]; then
      echo "Você selecionou a namespace $ns."

      # Verificar se existem políticas de rede na namespace selecionada
      policies=$(kubectl get networkpolicy -n $ns --no-headers -o custom-columns=":metadata.name")

      if [ -z "$policies" ]; then
        echo "Não há políticas de rede para a namespace $ns."
      else
        echo "Validando políticas de rede na namespace $ns..."

        # Validar cada política
        for policy in $policies; do
          # Aqui, são inseridas as regras de validação.

          # Verificar se a política permite o tráfego de qualquer origem (inseguro)
          is_insecure=$(kubectl get networkpolicy $policy -n $ns -o json | jq '.spec.ingress[0].from[0].ipBlock.cidr == "0.0.0.0/0"')

          # Verificar se a política permite tráfego para qualquer porta (inseguro)
          is_any_port=$(kubectl get networkpolicy $policy -n $ns -o json | jq '.spec.ingress[0].ports[0].port == null')

          # Verificar se a política não especifica um tipo de política (Egress ou Ingress)
          is_policy_type_missing=$(kubectl get networkpolicy $policy -n $ns -o json | jq '.spec.policyTypes == null')

          if [ "$is_insecure" == "true" ]; then
            echo "A política $policy permite tráfego de qualquer origem. Isso é inseguro."
          elif [ "$is_any_port" == "true" ]; then
            echo "A política $policy permite tráfego para qualquer porta. Isso é inseguro."
          elif [ "$is_policy_type_missing" == "true" ]; then
            echo "A política $policy não especifica um tipo de política (Egress ou Ingress). Isso pode ser confuso."
          else
            echo "A política $policy parece segura."
          fi
        done

        echo "Validação concluída."
      fi

      break
    else
      echo "Seleção inválida. Tente novamente."
    fi
  done
}


#====================================================================================
sarik-msg-exclusao(){
progress-bar2 $CONT2
clear
echo " "
echo $(echo -e ${VERDE}) "System network policies delete done!!" $(echo -e ${BRANCO})
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
}

sarik-msg-view(){
progress-bar2 $CONT2
clear
echo " "
echo $(echo -e ${VERDE}) "System network policies view done!!" $(echo -e ${BRANCO})
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
}

sarik-msg-default(){
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
}

#--------------------------------------------------------------------------------------#