#!/usr/bin/env bash

# Build AND Deploy

./mvnw clean package \
    -Dquarkus.container-image.build=true \
    -Dquarkus.kubernetes-client.trust-certs=true \
    -Dquarkus.openshift.deployment-kind=Deployment \
    -Dquarkus.kubernetes.deploy=true

