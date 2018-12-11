#!/usr/bin/env bats

load ../k8s-euft/env

@test "Deploy Traefik cluster" {
  helm upgrade --install --force --values tests/traefik/traefik.yaml traefik kubernetes
}

@test "Wait for traefik to be ready" {
    CURRENT_NODES=0
    READY_NODES=0

    # Ensure the number of desired pod has been bootstraped
    while [ "$CURRENT_NODES" != "$NUM_NODES" ] ; do
        sleep 5
        CURRENT_NODES=$(kubectl get pod -l app=traefik | grep Running | wc -l)
        echo "Kubernetes running nodes: $CURRENT_NODES/$NUM_NODES, waiting..." >&3
    done

    # Ensure the state of each pod is fully ready
    while [ "$READY_NODES" != "$NUM_NODES" ] ; do
        sleep 5
        READY_NODES=$(kubectl get pod -l app=traefik | awk '{ print $2 }' | grep -v READY | awk -F'/' '{ print ($1 == $2) ? "true" : "false" }' | grep true | wc -l)
        echo "Kubernetes running ready nodes: $READY_NODES/$NUM_NODES, waiting..." >&3
    done
}

@test "Ensure Traefik has config in Consul" {
  kubectl exec -it consul-0 consul kv get /traefik/consul/endpoint
  if [ $? -ne 0 ] ; then
    echo "Error while getting consul key info"
    exit 1
  fi
}

@test "Check that ping port is working fine" {
  instance_name=$(kubectl get po -l app=traefik | awk '/^traefik/{ print $1 }' | tail -1)
  if [ "$(kubectl exec -it $instance_name curl http://127.0.0.1:8081/ping)" != 'OK' ] ; then
    echo "Error while getting consul key info"
    exit 1
  fi
}
