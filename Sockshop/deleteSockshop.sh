#!/bin/bash -e
export OS_PUBLIC_IP="13.92.239.40"
export OS_PUBLIC_HOSTNAME="os-dt.eastus.cloudapp.azure.com"
export OS_PULL_DOCKER_IMAGES="true"

# SET env var
OS_PUBLIC_HOSTNAME="${OS_PUBLIC_HOSTNAME:-$OS_PUBLIC_IP}"

export loginserver=`echo "https://${OS_PUBLIC_HOSTNAME}:8443"`
oc login "${loginserver}" -u system:admin

oc delete -f manifests/sockshop-app/dev/
oc delete -f manifests/sockshop-app/production/
oc delete -f manifests/backend-services/orders-db/
oc delete -f manifests/backend-services/catalogue-db/
oc delete -f manifests/backend-services/carts-db/
oc delete -f manifests/backend-services/shipping-rabbitmq/dev/
oc delete -f manifests/backend-services/user-db/dev/
oc delete -f manifests/backend-services/shipping-rabbitmq/production/
oc delete -f manifests/backend-services/user-db/production/
oc delete project dev
oc delete project production
