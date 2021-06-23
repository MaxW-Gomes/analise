#!/bin/bash

function missingParam() {
    echo "[FATAL] Missing param(s): " "${@}"
    exit 1
}

function getEnvVar() {
    arquivo="/home/${USER}/.env"
    requestedVar="${1}"
    requestedVarValue=$(grep "${requestedVar}" "${arquivo}" | cut -d '=' -f2 | awk -F'"' '{print $2}')
    if [[ -z "${requestedVarValue}" ]]; then
        missingParam ".env variable '${requestedVar}'"
    fi
    echo "${requestedVarValue}"
}

directoryCaptcha='/teste.txt'
apiKey=$(getEnvVar "apikeyReidoscoins")
apiSecret=$(getEnvVar "apiSecretReidoscoins")
loadAverageLimit=$(nproc);

function insertCaptcha(){
  curl "https://waf.sucuri.net/api?v2" \
--data "k=$apiKey" \
--data "s=$apiSecret" \
--data "a=update_setting" \
--data "twofactorauth_path=$directoryCaptcha" \
--data "twofactorauth_type=captcha"
}

function removeCaptcha(){
  curl "https://waf.sucuri.net/api?v2" \
--data "k=$apiKey" \
--data "s=$apiSecret" \
--data "a=update_setting" \
--data "item_twofactorauth_path[]=$directoryCaptcha"
}

loadAverage=$(uptime | awk '{print $10}' | awk -F',' '{print $1}')

function isLoadAverageAboveLimit() {
    if [[ "$loadAverage" -gt "$loadAverageLimit" ]]; then
        echo 1
        exit
    fi
    echo 0
}

if isLoadAverageAboveLimit; then
  insertCaptcha;
  exit 1;
fi

removeCaptcha

