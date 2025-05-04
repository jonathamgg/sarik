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
#      - Add Module 10
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

#----------------------------------MODULOS---------------------------------------------#

# Carregando todas as funções e variáveis
source variables.sh
source function.sh

# Módulo Padrão: Configuração Automática de Regras


configure_firewall_rules_auto() {
  echo "Configurando regras de firewall automaticamente..."
sleep 5
# Especificando a namespace
NAMESPACE=$VALUE_NAMESPACE

# Coletando informações dos pods
kubectl get pods -n $NAMESPACE | awk '{if(NR>1)print $1}' > ngetPods.txt
readarray pods < ngetPods.txt

# Armazena cada linha do resultado do comando em um array
resultado1=($(kubectl get services -n $NAMESPACE -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'))

# Inicializa o array de colunas para serem usados no JSON do networkPolicy
colunas=()

# Itera sobre cada linha do resultado
for linha in "${resultado1[@]}"; do
    # Armazena cada coluna da linha em um array
    colunas+=($(echo $linha))
done

CONT3=0

#Criação do diretorio para as regras

if [ -d "policies" ]; then
    #Deletetando regras existentes no diretório
    rm -R policies/* 2>/dev/null
  else
    #criando o diretório
    mkdir policies
fi


# Criando array com as portas a serem bloqueadas
BLOCKED_PORTS=(7 80 443 22)

EXISTING_POLICIES=$(kubectl get networkpolicy -n $NAMESPACE --no-headers 2>/dev/null)

if [[ ! -z "$EXISTING_POLICIES" ]]; then
   echo "Já existem políticas de rede para o namespace $NAMESPACE."
   read -p "Deseja continuar e aplicar novas regras? (y/N): " choice
   case "$choice" in
     y|Y ) echo "Continuando..."
           sleep 2
progress-bar2 $CONT2
# Loop para percorrer cada pod
for pod in ${pods[@]}; do
    # Loop para percorrer cada porta a ser bloqueada
    for i in "${BLOCKED_PORTS[@]}"; do
        # Cria a regra de egress para a porta atual
        cat > policies/$(echo block-egress-$pod-$i.yaml) <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-ports-egress-$pod-$i
  namespace: $NAMESPACE
spec:
  podSelector:
    matchLabels:
      app: $(echo ${colunas[$CONT3]})
  policyTypes:
  - Egress
  egress:
  - ports:
    - protocol: TCP
      port: $i
  - to:
    - podSelector:
        matchLabels:
          app: $(echo ${colunas[$CONT3]})
EOF
    done
    ((CONT3=CONT3+1))
done

#Aplicando as políticas de rede no cluster
kubectl apply -f policies/

#Chamando a função para imprimir mensagem de conclusão
sarik-msg-default;;

     * ) echo "Operação cancelada pelo usuário."; exit 1;;
   esac
 else
   echo "Não há políticas de rede existentes para o namespace $NAMESPACE."
   echo "Prosseguindo com a aplicação das novas regras..."
progress-bar2 $CONT2
# Loop para percorrer cada pod
for pod in ${pods[@]}; do
    # Loop para percorrer cada porta a ser bloqueada
    for i in "${BLOCKED_PORTS[@]}"; do
        # Cria a regra de egress para a porta atual
        cat > policies/$(echo block-egress-$pod-$i.yaml) <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-ports-egress-$pod-$i
  namespace: $NAMESPACE
spec:
  podSelector:
    matchLabels:
      app: $(echo ${colunas[$CONT3]})
  policyTypes:
  - Egress
  egress:
  - ports:
    - protocol: TCP
      port: $i
  - to:
    - podSelector:
        matchLabels:
          app: $(echo ${colunas[$CONT3]})
EOF
    done
    ((CONT3=CONT3+1))
done

#Aplicando as políticas de rede no cluster
kubectl apply -f policies/
sleep 5
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
fi
}

#----------------------------------MODULOS---------------------------------------------#