
Register an existing compnent via:

https://github.com/buuhsmead/grpc-with-quarkus/blob/main/catalog/catalog-info.yaml


A Group must be created inside Keycloak, so that it can be sync'd to RHDH
quarkusapp-dev-team

From whitin Keycloak add to Group 'quarkusapp-dev-team' the user 'backstageuser'.



https://www.npmjs.com/package/@backstage-community/plugin-redhat-argocd

annotations: - catalog-info.yaml - Component.yaml
  argocd/app-name: <argoproj.io/v1alpha1.Application.metadata.name> - argocd # DONOT instead use 'argocd/app-selector
  argocd/app-selector: 'app=grpc-with-quarkus'
  backstage.io/kubernetes-id: 'quarkusapp' <BACKSTAGE_ENTITY_NAME> - argocd
  backstage.io/kubernetes-namespace: 'pp-team-b' <RESOURCE_NS> <NAMESPACE for Deployment> - argocd
  backstage.io/kubernetes-label-selector: 'app=grpc-with-quarkus'





ONLY: either 'argocd/app-name' OR 'argocd/app-selector' but not BOTH
Best result with 'argocd/app-selector' !!!


RHDH looks inside ArgoCD with the following:
/api/argocd/argoInstance/developer-gitops/applications/selector/app%3Dgrpc-with-quarkus?selector=app%253Dgrpc-with-quarkus
with this in the catalog/component:
argocd/app-selector: "app=grpc-with-quarkus"



== ArgoCD API

ARGOCD_SERVER="https://developer-gitops-server-developer-gitops.apps.west.jgmpn.gcp.redhatworkshops.io"

SWAGGER="${ARGOCD_SERVER}/swagger-ui"


curl -k $ARGOCD_SERVER/api/v1/session -d $'{"username":"admin","password":"ZeerGeheim"}' -H "Content-Type: application/json"

curl -k $ARGOCD_SERVER/api/v1/applications -H "Authorization: Bearer $ARGOCD_TOKEN"


$ curl $ARGOCD_SERVER/api/v1/session -d $'{"username":"admin","password":"password"}'
{"token":"eyJhbG..._KIdVwao"}

$ curl $ARGOCD_SERVER/api/v1/applications -H "Authorization: Bearer $ARGOCD_TOKEN"
{"metadata":{"selfLink":"/apis/argoproj.io/v1alpha1/namespaces/argocd/applications","resourceVersion":"37755"},"items":...}
