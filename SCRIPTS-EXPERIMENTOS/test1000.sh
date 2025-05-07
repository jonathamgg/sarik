#!/bin/bash

# Define a namespace
namespace=vote

# Obtém a lista de pods na namespace
pods=$(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')
CLUSTER_IP=$(kubectl describe services kubernetes | grep Endpoints: | awk '{print $NF}' | cut -d':' -f1)

# Loop para instalar os programas em cada pod
for pod in $pods; do
echo ""
    echo "O nome do pod e: $(echo -e ${VERMELHO} $pod) $(echo -e ${BRANCO})"
    echo ""
        # criação s arquivos do 1º expeimento

        echo "Data; Group; Nome_POD; PING; WGET; CURL; APT" > metricas_tempo_resposta_pod_$pod.csv

        echo "Group,PING,WGET,CURL,APT" > metricas_para_R_pod_$pod.csv

        for i in {1..1}
         do
                 echo "O nome do pod e: $(echo -e ${VERMELHO} $pod) $(echo -e ${BRANCO})"
                 echo "Esse e o loop: $(echo -e ${VERDE} $i) $(echo -e ${BRANCO})"
                 echo ""

# Coletar o tempo de resposta dos seguintes comandos: ping, wget, curl e apt


           ####################################  PING ################################
           TEMPO_DE_RESPOTA_START=0
           TEMPO_DE_RESPOTA_FIM=0
           DIVISOR=1000000 # faz a conversao para segundos


           timeout=$(shuf -i 10-15 -n 1)  #gerando um tempo aleatorio de 15 ate 20 segundos

	   echo "O tempo aleatorio e: $timeout"
           TEMPO_DE_RESPOTA_START=$(date +%s)
           INICIO=$(echo "scale=16; $TEMPO_DE_RESPOTA_START / $DIVISOR" | bc)
	   echo "inicio: $INICIO"
           INICIO=$(echo "$INICIO" | sed 's/[^0-9,]//g')

           # Executando o comando no POD
           # kubectl exec -it $pod -n $namespace -- ping -w $timeout -c 8 $CLUSTER_IP

           # Usando o timeout para definir um limite de tempo em todos os comandos.
           timeout $timeout kubectl exec -it $pod -n $namespace -- ping -c 8 $CLUSTER_IP

           TEMPO_DE_RESPOTA_FIM=$(date +%s)
	   TEMPO_DE_RESPOTA_FIM=$(echo $TEMPO_DE_RESPOTA_FIM + $TEMPO_DE_RESPOTA_START | bc)
           FIM=$(echo "scale=16; $TEMPO_DE_RESPOTA_FIM / $DIVISOR" | bc)
	   echo "FIM: $FIM"
           FIM=$(echo "$FIM" | sed 's/[^0-9,]//g')


           RESULT_TR_PING=$(echo "$FIM - $INICIO" | bc)
	   #RESULT_TR_PING=$(echo "scale=10; $RESULT_TR_PING / 1000000" | bc)
	   echo ""
	   echo "$RESULT_TR_PING"
	   echo "" 
	   ####################################  PING ################################
	done
done
