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
#      - Add Module 9
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

# Módulo *: Ajuda com 'h'
show_help() {
  echo "Uso: ./sarik.sh [opções]"
  echo "Opções:"
  echo "  -h, --help        Mostrar esta ajuda"
  echo "  -mn, --manual      Configurar políticas de rede manualmente (interface de saída)"
  echo "  -D, --delete      Exclusão de todas políticas de rede automaticamente"
  echo "  -l, --view        Visualização políticas de rede"
  echo "  -d, --del         Exclusão de políticas de rede individualmente"
  echo "  -i, --ingress     Configurar políticas de rede manualmente (interface de entrada)"
  echo "  -m, --monitor     Monitorar o impacto das políticas de rede"
  echo "  -b, --backup      Fazer backup das políticas de rede atuais"
  echo "  -v, --validate    Validar as políticas de rede (EXPERIMENTAL)"
}