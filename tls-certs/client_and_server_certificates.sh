#!/usr/bin/env bash

# https://access.redhat.com/articles/6891491


#export FQDN=star.cloud.daems.org
export FQDN=huub-nui-active2-gateway



export OPENSSL_HOME=/usr/local/Cellar/openssl@3/3.1.3/
export OPENSSL=${OPENSSL_HOME}/bin/openssl

# Create the CA certificate and private key to sign the certificate for your services:
$OPENSSL req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj "/O=example Inc./CN=$FQDN" -keyout CA.key -out CA.crt

# Create the Server certificate and private key:
$OPENSSL req -out server.csr -newkey rsa:2048 -nodes -keyout server.key -subj "/CN=$FQDN/O=server organization"
$OPENSSL x509 -req -days 365 -CA CA.crt -CAkey CA.key -set_serial 0 -in server.csr -out server.crt

# Generate the Client certificate and private key:
$OPENSSL req -out client.csr -newkey rsa:2048 -nodes -keyout client.key -subj "/CN=$FQDN/O=client organization"
$OPENSSL x509 -req -days 365 -CA CA.crt -CAkey CA.key -set_serial 1 -in client.csr -out client.crt

rm ./*csr



