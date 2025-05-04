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
#      - Add Module 1
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


# Módulo 1: Cadastrar regras manuais na interface de saída (egress)


# Criando o diretorio para criação das regras individuais, caso contrário, exclui a regras nesse diretorio
if [ -d "egress" ]; then
    #Deletetando regras existentes no diretório
    rm -R egress/* 2>/dev/null
  else
    #criando o diretório
    mkdir egress
fi

configure_firewall_rules_manual() {
  echo "Configurando políticas de rede manualmente..."
  sleep 3
  progress-bar2 $CONT2
# Listar todas as namespaces e permitir que o usuário selecione uma
namespaces=$(kubectl get namespaces --no-headers -o custom-columns=":metadata.name")
echo "Selecione uma namespace:"
select ns in $namespaces; do
  if [[ -n "$ns" ]]; then
    break
  else
    echo "Seleção inválida. Tente novamente."
  fi
done

# Listar todos os pods na namespace selecionada e permitir que o usuário selecione um
pods=$(kubectl get pods -n $ns --no-headers -o custom-columns=":metadata.name")
echo "Selecione um pod:"
select pod in $pods; do
  if [[ -n "$pod" ]]; then
    break
  else
    echo "Seleção inválida. Tente novamente."
  fi
done

while true; do
  # Perguntar ao usuário qual protocolo e porta ele deseja bloquear
  read -p "Informe o protocolo que você deseja bloquear (ex: TCP, UDP): " protocol
  read -p "Informe a porta que você deseja bloquear: " port

  # Criar a regra de bloqueio
  egress/create_block_rule $pod $ns $protocol $port

  # Perguntar ao usuário se ele deseja continuar
  read -p "Deseja continuar adicionando regras? (y/N): " choice
  if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
    break
  fi
done

# Aplicar todas as regras
kubectl apply -f egress/

echo "Regras aplicadas com sucesso."
}