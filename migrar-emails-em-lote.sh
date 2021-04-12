#!/bin/bash

# Nesse script, no primeiro parãmetro deve ser passado o nome do servidor de origem. 
# No segundo parãmetro seria o servidor de destino. 
# Por final, no terceiro parâmetro seria a quantidade de contas a serem migradas

ORIGEM="${1}";
DESTINO="${2}";

declare -a EMAIL_ARRAY;
declare -a SENHA_ARRAY_ORIGEM;
declare -a SENHA_ARRAY_DESTINO;
declare -i qtdContas;

qtdContas="${3}"; 

## Esse for é usado para pegar os dados( conta de emails, senha de origem e senha de destino).
for i in $(seq $qtdContas); do
	echo "Digite o nome da conta número ${i}:";
	read EMAIL_ARRAY[i];
	echo "";
	read -p "Senha da conta no servidor - ${ORIGEM} : " -s  SENHA_ARRAY_ORIGEM[i];
	echo "";
	read -p "Senha da conta no servidor - ${DESTINO} : " -s  SENHA_ARRAY_DESTINO[i];
	echo "---------,,-------------";
done
 
for i in $(seq ${#EMAIL_ARRAY[@]}); 
	do
		echo "${EMAIL_ARRAY[$i]}" ;
		
		imapsync --host1 $ORIGEM --port1 993 --ssl1 \
			--user1 "${EMAIL_ARRAY[$i]}" \
		  --password1 "${SENHA_ARRAY_ORIGEM[$i]}" \
		  --host2 $DESTINO --port2 993 --ssl2 \
		  --user2 "${EMAIL_ARRAY[$i]}" \
		  --password2 "${SENHA_ARRAY_DESTINO[$i]}";
	done
