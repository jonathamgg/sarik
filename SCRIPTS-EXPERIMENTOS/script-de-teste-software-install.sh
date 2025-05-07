#!/bin/bash

# Define a namespace
namespace=vote

# Obtém a lista de pods na namespace
pods=$(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')

# Cria um arquivo de log vazio
touch log.txt

# Loop para testar cada pod
for pod in $pods; do
    # Testa se o programa ping está instalado
    kubectl exec -it $pod -n $namespace -- ping -c 1 google.com
    if [ $? -ne 0 ]; then echo "$pod: ping" >> log.txt; fi

    # Testa se o programa scp está instalado
    kubectl exec -it $pod -n $namespace -- scp
    if [ $? -ne 0 ]; then echo "$pod: scp" >> log.txt; fi

    # Testa se o programa wget está instalado
    kubectl exec -it $pod -n $namespace -- wget
    if [ $? -ne 0 ]; then echo "$pod: wget" >> log.txt; fi

    # Testa se o programa curl está instalado
    kubectl exec -it $pod -n $namespace -- curl
    if [ $? -ne 0 ]; then echo "$pod: curl" >> log.txt; fi

    # Testa se o programa ftp está instalado
    kubectl exec -it $pod -n $namespace -- ftp -h
    if [ $? -ne 0 ]; then echo "$pod: ftp" >> log.txt; fi
done

