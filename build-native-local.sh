#!/usr/bin/env bash

./mvnw clean install \
  -Dnative -Dquarkus.native.container-build=true \
  -Dquarkus.container-image.build=true
