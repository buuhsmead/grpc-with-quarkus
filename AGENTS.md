# AGENTS.md - grpc-with-quarkus

## Project Overview
- Quarkus 3.2.11.Final (Red Hat build) application with gRPC, Camel, and OpenShift deployment
- Java 17, Maven wrapper (`./mvnw`) for all builds
- Single-module project: `pom.xml` at root

## Build & Run Commands

### Development
```bash
./mvnw compile quarkus:dev          # Dev mode with live reload
```

### Build
```bash
./mvnw package                       # Standard JVM build → target/quarkus-app/
./mvnw package -Pnative              # Native build (requires GraalVM)
./mvnw package -Pnative -Dquarkus.native.container-build=true  # Native in container
```

### Container Build (OpenShift)
```bash
./build.sh                           # Build container image only
./build-native-local.sh              # Native image + container build
./deploy.sh                          # Build + deploy (incomplete script)
```

### Test
```bash
./mvnw test                          # Run unit tests
./mvnw verify                        # Run integration tests (if enabled)
```

## Architecture

### Core Services
- **gRPC**: `src/main/proto/hello.proto` → generated at build time via `quarkus-maven-plugin`
- **gRPC Service**: `src/main/java/org/acme/HelloGrpcService.java`
- **Camel Routes**: `src/main/java/org/acme/camel/TimerRoute.java`
- **REST Endpoint**: `src/main/java/org/acme/GreetingResource.java`
- **Probes**: Custom liveness/readiness/startup probes in `src/main/java/org/acme/probes/`

### Deployment Targets
- **OpenShift namespace**: `tls-test` (configured in `application.properties`)
- **Container image group**: `tls-test/grpc-with-quarkus`
- **Deployment kind**: `Deployment` (not DeploymentConfig)
- **Service account**: `grpc-with-quarkus`

### Kustomize Overlays
```
kustomize/base/
├── app/           # Main deployment manifests (bc, dc, is, route, sa, svc)
├── grpcurl/       # gRPC testing tooling
├── ingress-aws/   # AWS ingress configuration
└── mesh/          # Service mesh configuration
```

## GitOps & Catalog

### ArgoCD
- Application manifest: `argocd/Application.yaml`
- Syncs `kustomize/base/app` to `app-team-b` namespace
- Auto-sync enabled with prune and self-heal

### Backstage (RHDH)
- Catalog location: `catalog/catalog-info.yaml`
- References: `group.yaml`, `system.yaml`, `quarkus-db.yaml`, `quarkusapp.yaml`, `quarkusappapi.yaml`
- ArgoCD annotation: `argocd/app-selector: "app=grpc-with-quarkus"`

## Key Configuration

### application.properties
- `quarkus.openshift.namespace=tls-test`
- `quarkus.openshift.route.expose=true`
- `quarkus.http.insecure-requests=ENABLED`
- Resource limits: 250Mi memory, 100m CPU

### Red Hat Maven Repository
- All dependencies from `https://maven.repository.redhat.com/ga`
- BOM: `quarkus-bom` and `quarkus-camel-bom` from Red Hat platform

## Development Notes
- gRPC Java classes generated during `generate-code` phase - do not hand-edit
- Dev UI available at `http://localhost:8080/q/dev/` in dev mode
- Health checks at `/health` (SmallRye Health)
- Prometheus metrics enabled (Micrometer)

## Gotchas
- `deploy.sh` is incomplete (only runs `mvnw package`)
- Integration tests skipped by default (`skipITs=true`)
- Native tests require `skipITs=false` via `-Pnative` profile
