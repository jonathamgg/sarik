# Tutorial de Instalação do Minikube no Ubuntu 24.04 via WSL2

## Pré-requisitos
- **WSL2** com Ubuntu 24.04
- Acesso administrativo (`sudo`)
- Mínimo recomendado: 4GB RAM + 2 CPUs

## Passo a Passo

### 1. Atualizar o Sistema
- bash

sudo apt update && sudo apt upgrade -y

### 2. Instalação do Docker

# Dependências
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Chave GPG e repositório

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# Instalação

sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io

# Configuração de permissões

sudo usermod -aG docker $USER

newgrp docker

sudo service docker start

### 3. Instalação do kubectl

# Repositório Kubernetes

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Instalação

sudo apt update

sudo apt install -y kubectl

### 4. Instalação do Minikube

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube


### Inicializando o cluster minikube

# Iniciar cluster

minikube start --driver=docker --memory=4096 --cpus=2 --cni=calico

# Verificar status

minikube status
