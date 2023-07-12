#!/usr/bin/env bash

# Only Build NO Deploy

./mvnw clean package \
    -Dquarkus.container-image.build=true \
    -Dquarkus.kubernetes-client.trust-certs=true
