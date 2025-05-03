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
#      Access the director AppTest/minikube
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
#  V1.03 04/08/2023, Jonathan G.P. dos Santos
#      - Add networkpolicy
#      - Add Modules for CRUD
#  V1.04 01/10/2023, Jonathan G.P. dos Santos
#      - Add networkpolicy ingress
#      - Add Modules 6 nd 7
#  V1.05 05/10/2023, Jonathan G.P. dos Santos
#      - Add Modules and function
#--------------------------------------------------------------------------------------#
#Testado em:
#  bash 5.0.17
#
#
#--------------------------------------------------------------------------------------#
#Agradecimentos:
#
#   Dr. Vinícius Pereira Gonçalves  - Orientador do projeto
#   Dr. Geraldo Pereira Rocha Filho - Coorientador do projeto
#   MSc. Elivaldo Ribeiro De Santana - Estatística 
#   Luiz Eduardo Rodrigues Lima - Layout página SARIK e auxílio na pesquisa
#   Tainá Naró S. Moura - Revisão da escrita dos artigos
#   Juliana Cristina Sampaio Silva - Revisão da escrita do pré-projeto
#   Dr. Hervaldo Sampaio Carvalho - Pelo apoio e supervisão
#   Dr. Gustavo Adolfo Sierra Romero - Pelo apoio e supervisão
#
#--------------------------------------------------------------------------------------#

# Carregando todos os módulos, function and variables
source module1.sh
source module2.sh
source module3.sh
source module4.sh
source module5.sh
source module6.sh
source module7.sh
source module8.sh
source module9.sh
source module10.sh
source variables.sh
source function.sh

# Criando os diretórios, caso seja necessário

# Checa se o diretório policies existe
if [ ! -d "policies" ]; then
  # Cria o diretório policies caso não exista
  mkdir policies
fi

# Checa se o diretório backup_policies existe
if [ ! -d "backup_policies" ]; then
  # Cria o diretório backup_policies caso não exista
  mkdir backup_policies
fi

# Checa se o diretório egress existe
if [ ! -d "egress" ]; then
  # Cria o diretório egress caso não exista
  mkdir egress
fi

# Checa se o diretório ingress existe
if [ ! -d "ingress" ]; then
  # Cria o diretório ingress caso não exista
  mkdir ingress
fi

# Ative extglob logo no início
shopt -s extglob

# Verificar o diretório atual

CURRENT_DIR=$(pwd)
TARGET_DIR="SARIK"

  if [[ $CURRENT_DIR == *$TARGET_DIR ]]; then
    
    sleep 1
    # Remove todos os arquivos dos diretórios
    rm -R policies/*
    rm -R backup_policies/*
    rm -R ingress/*
    rm -R egress/*

  else
    echo "Por favor, crie a pasta 'SARIK' e coloque este(s) script(s) dentro deste diretório."
    sleep 2
    exit 1
  fi

# Desative extglob se não for mais necessário
shopt -u extglob


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
sleep 1
echo "Dr. Geraldo Pereira Rocha Filho - Coorientador do projeto"
sleep 1
echo " "
echo " "
#--------------------------------------------------------------------------------------#

#---------------------------------TESTES-----------------------------------------------#
#Docker install?
#[ ! -x "$(which docker)" ] && printf "Precisa instalar o docker, por favor, instale.\n" && exit 1
#minikube install?
#[ ! -x "$(which minikube)" ] || [ ! -x "$(which kubectl)" ] && printf "Precisa instalar o minikube ou kubectl, por favor, instale.\n" && exit 1
#--------------------------------------------------------------------------------------#

#---------------------------------EXECUÇÃO---------------------------------------------#
#
main() {
  #Fazendo uma checagem caso tenha passado parametro no script
  if [ "$#" -eq 0 ]; then
    configure_firewall_rules_auto
    exit 0
  fi

  while [ "$1" != "" ]; do
    case $1 in
      -mn | --manual )
        configure_firewall_rules_manual
        ;;
      -D | --delete )
        delete_rules_auto
        ;;
      -l | --view )
        view_networkpolicy
        ;;
      -d | --del )
        delete_networkpolicy
        ;;
      -i | --ingress )
        configure_firewall_rules_ingress
        ;;
      -m | --monitor )
        policies-monitor
        ;;
      -b | --backup )
        backup
        ;;
      -v | --validate )
        validate
        ;;
      -h | --help )
        show_help
        ;;
      * )
        echo "Opção inválida: $1"
        exit 1
    esac
    shift
  done
}

# Chama a função principal com todos os argumentos passados para o script
main "$@"
#--------------------------------------------------------------------------------------#