oc login https://dynatrace-os.eastus.cloudapp.azure.com:8443 -u developer  -p developer --insecure-skip-tls-verify
oc apply -f manifests/sockshop-app/dev/carts2.yml

