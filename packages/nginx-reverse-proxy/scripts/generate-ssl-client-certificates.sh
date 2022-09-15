#!/bin/bash

set -e
set -u
: "${CLIENT_ID:?Variable not set or empty}"
: "${PASSWORD:?Variable not set or empty}"

CA_CERT_NAME=${CA_CERT_NAME:-ca}
CLIENT_CERT_NAME=${CLIENT_CERT_NAME:-$CLIENT_ID}

openssl genrsa -aes256 -passout pass:${PASSWORD} -out ${CLIENT_CERT_NAME}.pass.key 4096
openssl rsa -passin pass:${PASSWORD} -in ${CLIENT_CERT_NAME}.pass.key -out ${CLIENT_CERT_NAME}.key
rm ${CLIENT_CERT_NAME}.pass.key
openssl req -new -key ${CLIENT_CERT_NAME}.key -out ${CLIENT_CERT_NAME}.csr
openssl x509 -req -days 3650 -in ${CLIENT_CERT_NAME}.csr -CA ${CA_CERT_NAME}.pem -CAkey ${CA_CERT_NAME}.key -set_serial ${SERIAL_ID:-01} -out ${CLIENT_CERT_NAME}.pem -sha256
cat ${CLIENT_CERT_NAME}.key ${CLIENT_CERT_NAME}.pem ${CA_CERT_NAME}.pem > ${CLIENT_CERT_NAME}.full.pem
openssl pkcs12 -export -out ${CLIENT_CERT_NAME}.full.pfx -inkey ${CLIENT_CERT_NAME}.key -in ${CLIENT_CERT_NAME}.pem -certfile ${CA_CERT_NAME}.pem