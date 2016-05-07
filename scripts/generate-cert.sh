#!/bin/bash -eux
host=$1

if [[ ! -e $host.key ]]; then
  openssl req -new -days 3650 -nodes -x509 -sha256 \
    -subj "/CN=*.$host" \
    -keyout $host.key \
    -out $host.crt
fi

if [[ ! -e $host.dhparam.pem ]]; then
  openssl dhparam -out $host.dhparam.pem 2048
fi
