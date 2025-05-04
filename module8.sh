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
#      - Add Module 8
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

# Módulo 8: Validate

validate(){
# Verificar se o usuário quer validar as políticas
read -p "Você deseja validar as políticas de rede? (y/N): " choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
  validate_policies
else
  echo "Validação de políticas de rede cancelada."
fi
}