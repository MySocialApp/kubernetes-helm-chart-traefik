#!/usr/bin/env bats

load ../k8s-euft/env
load common

@test "Ensure number of nodes is set: $NUM_NODES" {
    num_nodes_set
}

@test "Ensure nodes has correct labels" {
    num_nodes_are_labeled_as_node
}

@test "Deploy Consul cluster" {
  rm -Rf kubernetes-helm-chart-consul
  git clone https://github.com/MySocialApp/kubernetes-helm-chart-consul.git
  cd kubernetes-helm-chart-consul
  helm upgrade --install --force --values ../tests/consul/consul.yaml consul kubernetes
}

@test "Waiting consul to be ready" {
  while [ $(kubectl get po -l app=consul | grep -c Running) != 3 ] ; do
    sleep 5
  done
  echo "Consul is ready"
}
