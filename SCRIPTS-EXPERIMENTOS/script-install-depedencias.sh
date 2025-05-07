#!/bin/bash

# Define a namespace
namespace=vote

# Obtém a lista de pods na namespace
pods=$(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')

# Loop para instalar os programas em cada pod
for pod in $pods; do
    # Verifica se o pod usa imagem Alpine
    if [[ $(kubectl exec -it $pod -n $namespace -- cat /etc/os-release | grep -c "Alpine") -ne 0 ]]; then
        # Instala os programas no pod usando o gerenciador de pacotes apk
        kubectl exec -it $pod -n $namespace -- apk add -q --no-cache curl ftp-client wget openssh-client
        kubectl exec -it $pod -n $namespace -- apk add -q --no-cache iputils
    else
        # Instala os programas no pod usando o gerenciador de pacotes apt
        kubectl exec -it $pod -n $namespace -- apt-get update -qq
        kubectl exec -it $pod -n $namespace -- apt-get install -qq --no-install-recommends curl ftp wget net-tools
    fi
done

