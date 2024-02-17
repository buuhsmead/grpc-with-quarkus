#!/usr/bin/env bash
#
#

export OPENSSL_HOME=/usr/local/Cellar/openssl@3/3.1.2/
export OPENSSL=${OPENSSL_HOME}/bin/openssl

export DOMAIN=tls-server.apps-crc.testing
export SAN="grpc-with-quarkus.${DOMAIN}"
export NS_SCMP=tls-server-istio


# huub-nui-active2-gateway.shared-service-development.app-nees.snuitac9ocp01-robuh1.ees.devtest.eulisa.local

export DOMAIN=shared-service-development.app-nees.snuitac9ocp01-robuh2.ees.devtest.eulisa.local
export SAN="huub-nui-active2-gateway.${DOMAIN}"
export NS_SCMP=istio-system



# Create a root certificate and private key to sign the certificates for your services:
${OPENSSL} req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/C=NL/O=BuuhSmead/CN=Self CA' -keyout CA.key -out CA.crt

# Generate a certificate and a private key for
${OPENSSL} req -out server.csr -newkey rsa:2048 -nodes -keyout server.key -subj '/CN=grpc-with-quarkus/O=freubel organization'
${OPENSSL} x509 -req -sha256 -days 365 -CA CA.crt -CAkey CA.key -set_serial 0 -in server.csr -out server.crt -extfile <(printf "subjectAltName=DNS:%s , DNS:huub-nui-active2-gateway.shared-service-development.app-nees.snuitac9ocp01-robuh2.ees.devtest.eulisa.local" "${SAN}")
rm -f server.csr


# Generate a client certificate and private key:
${OPENSSL} req -out client.csr -newkey rsa:2048 -nodes -keyout client.key -subj '/CN=grpc-with-quarkus/O=freubel organization'
${OPENSSL} x509 -req -sha256 -days 365 -CA CA.crt -CAkey CA.key -set_serial 1 -in client.csr -out client.crt
rm -rf client.csr


oc delete secret "igw-${NS_SCMP}" -n ${NS_SCMP}
#oc create -n ${NS_SCMP} secret generic "igw-${NS_SCMP}" --from-file=tls.key=server.key --from-file=tls.crt=server.crt --from-file=ca.crt=CA.crt
oc create -n ${NS_SCMP} secret generic "huub-nui-gateway" --from-file=tls.key=server.key --from-file=tls.crt=server.crt --from-file=ca.crt=CA.crt
curl -v --cacert CA.crt https://${SAN}/hello --cert client.crt --key client.key
