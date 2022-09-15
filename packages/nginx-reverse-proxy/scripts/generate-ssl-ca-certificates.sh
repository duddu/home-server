#!/bin/bash

set -e
set -u
: "${PASSWORD:?Variable not set or empty}"

CA_CERT_NAME=${CA_CERT_NAME:-ca}

openssl genrsa -aes256 -passout pass:${PASSWORD} -out ${CA_CERT_NAME}.pass.key 4096
openssl rsa -passin pass:${PASSWORD} -in ${CA_CERT_NAME}.pass.key -out ${CA_CERT_NAME}.key
rm ${CA_CERT_NAME}.pass.key
openssl req -new -x509 -days 3650 -key ${CA_CERT_NAME}.key -out ${CA_CERT_NAME}.pem