#!/bin/bash -e
export OS_PUBLIC_IP="13.92.239.40"
export OS_PUBLIC_HOSTNAME="os-dt.eastus.cloudapp.azure.com"
export OS_PULL_DOCKER_IMAGES="true"

# SET env var
OS_PUBLIC_HOSTNAME="${OS_PUBLIC_HOSTNAME:-$OS_PUBLIC_IP}"

# Run OpenShift
oc cluster up --public-hostname="${OS_PUBLIC_HOSTNAME}" --routing-suffix="${OS_PUBLIC_IP}.nip.io"

# Add cluster-admin role to user admin
#oc login https://ec2-52-221-223-60.ap-southeast-1.compute.amazonaws.com:8443 -u system:admin
export loginserver=`echo "https://${OS_PUBLIC_HOSTNAME}:8443"`
oc login "${loginserver}" -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin admin

# Add dynatrace as privileged user to the openshift-infra project
oc project openshift-infra
oc create serviceaccount dynatrace
oc adm policy add-scc-to-user privileged -z dynatrace
oc adm policy add-scc-to-user anyuid -z default -n dev
oc adm policy add-scc-to-user anyuid -z default -n production

oc login -u developer -p developer --insecure-skip-tls-verify

oc new-project "dev" --display-name="Development" --description="The Dynatrace Sockshop Dev sample application." || true
oc new-project "production" --display-name="Production" --description="The Dynatrace Sockshop Prod sample application." || true

oc login "${loginserver}" -u system:admin

oc apply -f manifests/backend-services/user-db/dev/
oc apply -f manifests/backend-services/user-db/production/
oc apply -f manifests/backend-services/shipping-rabbitmq/dev/
oc apply -f manifests/backend-services/shipping-rabbitmq/production/
oc apply -f manifests/backend-services/carts-db/
oc apply -f manifests/backend-services/catalogue-db/
oc apply -f manifests/backend-services/orders-db/
oc apply -f manifests/sockshop-app/dev/
oc apply -f manifests/sockshop-app/production/

#Create ClusterRoleBinding View to pull labels and annotations for dev namespace
oc -n dev create rolebinding default-view --clusterrole=view --serviceaccount=dev:default

#Create ClusterRoleBinding View to pull labels and annotations for prod namespace
oc -n production create rolebinding default-view --clusterrole=view --serviceaccount=production:default

oc project production
oc expose service/front-end
oc expose service/carts 

oc project dev
oc expose service/front-end
oc expose service/carts

