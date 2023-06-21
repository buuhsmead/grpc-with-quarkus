#!/usr/bin/env bash

# Build AND Deploy

./mvnw clean package \
    -Dquarkus.container-image.build=true \
    -Dquarkus.openshift.namespace=grpc-with-quarkus-dev \
    -Dquarkus.kubernetes-client.trust-certs=true \
    -Dquarkus.kubernetes.deploy=true

