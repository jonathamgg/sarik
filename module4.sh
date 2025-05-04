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
#      - Add Module 4
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

# Módulo 4: Exclusão de políticas de rede individuais

delete_networkpolicy(){
  echo "Aguarde, processando a solicitação..."
  sleep 3
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

# Listar todos os pods na namespace selecionada e permitir que o usuário selecione uma
pods=$(kubectl get pods -n $ns --no-headers -o custom-columns=":metadata.name")
echo "Selecione um pod:"
select pod in $pods; do
  if [[ -n "$pod" ]]; then
    break
  else
    echo "Seleção inválida. Tente novamente."
  fi
done

# Listar todas as políticas de rede para o pod selecionado
policies=$(kubectl get networkpolicy -n $ns --no-headers -o custom-columns=":metadata.name" | grep "$pod")
echo "Selecione uma política de rede para excluir:"
select policy in $policies; do
  if [[ -n "$policy" ]]; then
    break
  else
    echo "Seleção inválida. Tente novamente."
  fi
done

# Excluir a regra de bloqueio
port=$(echo $policy | awk -F '-' '{print $3}')
delete_block_rule $policy $ns

echo "Regra excluída com sucesso."

}