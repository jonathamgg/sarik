#!/usr/bin/env bash
VERDE="\033[32;1m"
cont=5
while [ $cont -gt 0 ]; do
	echo $(echo -e ${VERDE}) "System configuration done!!" $cont
	((cont=cont-1))
done
