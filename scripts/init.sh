#!/bin/bash
set -o allexport; source .env; set +o allexport
if [ ! -f ./conf/ssl/cacert.pem ]
then
    bash $PWD/scripts/createEnv.sh
    sudo apt install -y libnss3-tools;
    docker run --rm -v $PWD/conf/ssl:/certificates -e "SERVER=*.$ROOT_DOMAIN" -e "SUBJECT=/C=US/ST=Indiana/L=Bloomington/O=IT/OU=*.$ROOT_DOMAIN" jacoelho/generate-certificate;
    sudo mkdir -p /usr/local/share/ca-certificates/$ROOT_DOMAIN;
    sudo cp ./conf/ssl/cacert.pem /usr/local/share/ca-certificates/$ROOT_DOMAIN/cacert.pem;
    sudo chmod 755 /usr/local/share/ca-certificates/$ROOT_DOMAIN;
    sudo chmod 644 /usr/local/share/ca-certificates/$ROOT_DOMAIN/cacert.pem;
    if ! grep -Fxq "$ROOT_DOMAIN" /etc/hosts
    then
        echo "127.0.0.5    $ROOT_DOMAIN" | sudo tee --append /etc/hosts
    fi
    sudo update-ca-certificates
    ### Script installs root.cert.pem to certificate trust store of applications using NSS
    ### (e.g. Firefox, Thunderbird, Chromium)
    ### Mozilla uses cert8, Chromium and Chrome use cert9

    ###
    ### Requirement: apt install libnss3-tools
    ###


    ###
    ### CA file to install (CUSTOMIZE!)
    ###

    certfile="$PWD/conf/ssl/cacert.pem"
    certname="$ROOT_DOMAIN CA"


    ###
    ### For cert8 (legacy - DBM)
    ###

    for certDB in $(find ~/ -name "cert8.db")
    do
        certdir=$(dirname ${certDB});
        certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d dbm:${certdir}
    done


    ###
    ### For cert9 (SQL)
    ###

    for certDB in $(find ~/ -name "cert9.db")
    do
        certdir=$(dirname ${certDB});
        certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d sql:${certdir}
    done
fi
