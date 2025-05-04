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
#      - Add Module 3
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

# Módulo 3: Visualização das políticas de rede

view_networkpolicy() {
  echo "Aguarde, processando a solicitação..."
  sleep 3
  #Chamando a função para visualizar logo
  sarik-msg-view
VALUE_NAMESPACE=$(kubectl get namespace | awk '{print $1}' | grep -v ^'default' | grep -v ^NAME | grep -v ^kube)

  if [[ -z "$VALUE_NAMESPACE" ]]; then
    echo "Não há nespaces no cluster."
    exit 1
  else
    echo "Namespace(s) encontrado(s): $VALUE_NAMESPACE"
    echo " "
    for ns in $VALUE_NAMESPACE; do
      #Verificar se existem políticas de rede para o namespace
      NETWORK_POLICIES=$(kubectl get networkpolicy -n $ns --no-headers 2>/dev/null )

      if [[ -z "$NETWORK_POLICIES" ]]; then
        echo "Não há políticas de rede para o namespace $ns."
      else
        echo "Políticas de rede para o namespace $ns:"
        echo "$NETWORK_POLICIES"
      fi
    done
  fi
}