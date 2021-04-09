#!/bin/bash

function missingParam() {
    echo "[FATAL] Missing param(s): " "${@}"
    exit 1
}

function getEnvVar() {
    requestedVar="${1}"
    requestedVarValue=$(grep "${requestedVar}" "/home/mgomes/.env" | cut -d '=' -f2 | awk -F'"' '{print $2}')
    if [[ -z "${requestedVarValue}" ]]; then
        missingParam ".env variable '${requestedVar}'"
    fi
    echo "${requestedVarValue}"
}

user=$(getEnvVar "user")
secret=$(getEnvVar "secret")

#Pegando os id's de todas as faturas que não foram pagas e colocando no arquivo /tmp/id.txt

curl -sf "https://app.goinfinite.net/includes/api.php" \
    --data "username=${user}" \
    --data "password=${secret}" \
    --data "responsetype=json" \
    --data "action=GetInvoices" \
    --data "status=Unpaid" \
    --data "limitnum=920" \
    --data "orderby=duedate" \
    --data "order=desc" | jq '.invoices.invoice | .[].id' > /tmp/id.txt

#pegando o número de linhas e atribuindo o valor à variável quantidade

qtd=$(wc -l /tmp/id.txt | awk '{print $1}');

declare -a id;
declare -a subtotal;
declare -a balanco;
declare -a verificar;

#Logo abaixo será comparado o balanço com o total da fatura. Se o valor do balanço for menor que o total da fatura, o id será atribuido ao array verificar, que será utilizado para enviar a mensagem ao slack

for i in $(seq $qtd);
    do
        id[${i}]=$(sed -n "${i}p" /tmp/id.txt);

        subtotal[${i}]=$(curl -sf "https://app.goinfinite.net/includes/api.php" \
    --data "username=${user}" \
    --data "password=${secret}" \
    --data "responsetype=json" \
    --data "action=GetInvoice" \
    --data "invoiceid=${id[${i}]}" | jq .subtotal | awk -F'"' '{print $2}');

        balanco[${i}]=$(curl -sf "https://app.goinfinite.net/includes/api.php" \
    --data "username=${user}" \
    --data "password=${secret}" \
    --data "responsetype=json" \
    --data "action=GetInvoice" \
    --data "invoiceid=${id[${i}]}" | jq .balance | awk -F'"' '{print $2}' );

        if (( $(echo "${balanco[${i}]} < ${subtotal[${i}]}" | bc -l) ))
          then
            verificar[${i}]="https://app.goinfinite.net/admin/invoices.php?action=edit&id=${id[${i}]}";
          fi
done   

## Dados do slack
slackChannel="sandbox"
slackKey=$(getEnvVar "CHAT_BOT_KEY")
slackMessage="
As faturas abaixo foram parcialmente pagas:

$(echo "${verificar[@]}")
"
##

#Envio da mensagem ao slack
if [ ${#verificar[@]} -gt 0 ]
then
  curl --silent \
        --header "Content-type: application/json; charset=utf-8" \
        --header "Authorization: Bearer ${slackKey}" \
        --data "{'channel':'${slackChannel}','text':'${slackMessage}'}" \
        "https://slack.com/api/chat.postMessage" &>>/dev/null
fi
