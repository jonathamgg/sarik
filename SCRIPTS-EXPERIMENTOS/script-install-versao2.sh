#!/bin/bash

# Define a namespace
namespace=vote

# Obtém a lista de pods na namespace
pods=$(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')

# Cria um arquivo de log vazio
touch log.txt

# Loop para instalar os programas em cada pod
for pod in $pods; do
    # Verifica se o pod usa imagem Alpine
    if [[ $(kubectl exec -it $pod -n $namespace -- cat /etc/os-release | grep -c "Alpine") -ne 0 ]]; then
        # Instala os programas no pod usando o gerenciador de pacotes apk
        kubectl exec -it $pod -n $namespace -- apk add curl ftp-client wget openssh-client
        if [ $? -ne 0 ]; then echo "$pod: curl ftp-client wget openssh-client" >> log.txt; fi
        kubectl exec -it $pod -n $namespace -- apk add iputils
        if [ $? -ne 0 ]; then echo "$pod: iputils" >> log.txt; fi
    else
        # Instala os programas no pod usando o gerenciador de pacotes apt
        kubectl exec -it $pod -n $namespace -- apt-get update 
        kubectl exec -it $pod -n $namespace -- apt-get install curl ftp wget net-tools
        if [ $? -ne 0 ]; then echo "$pod: curl ftp wget net-tools" >> log.txt; fi
    fi
done
