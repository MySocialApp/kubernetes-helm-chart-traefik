#!/usr/bin/env bats

load ../k8s-euft/env

@test "Deploy Traefik cluster" {
  helm upgrade --install --force --values tests/traefik/traefik.yaml traefik kubernetes
}

@test "Waiting all Traefik to be ready" {
  while [ $(kubectl get po -l app=traefik | grep -c Running) != 3 ] ; do
    sleep 5
  done
  echo "Traefik is ready"
}

@test "Ensure Traefik has config in Consul" {
  kubectl exec -it consul-0 consul kv get /traefik/consul/endpoint
  if [ $? -ne 0 ] ; then
    echo "Error while getting consul key info"
    exit 1
  fi
}