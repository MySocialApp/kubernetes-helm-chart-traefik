# Kubernetes Helm Chart for Treafik HA [![Build Status](https://travis-ci.org/MySocialApp/kubernetes-helm-chart-traefik.svg?branch=master)](https://travis-ci.org/MySocialApp/kubernetes-helm-chart-traefik)

You can find here a helm chart we're using at [MySocialApp](https://mysocialapp.io) (iOS and Android social app builder - SaaS)

[Traefik](https://traefik.io/) in HA mode require to store its configuration into a distributed KV store. The current recommendation is using [Consul](https://www.consul.io/).

It you want to use [let's encrypt](https://letsencrypt.org/) to generate certificates, it will also be required. We made a [Consul chart](https://github.com/MySocialApp/kubernetes-helm-chart-consul) for it or you can use another one.

We made this chart because we want to get rid of manually managing bootstraping onto consul and have let's encrypt support with DNS challenge.

# What does this chart do

* Deploy traefik
* Boostrap traefik configuration inside consul kv store
* Manage let's encrypt certificates with DNS challenge on Cloudflare
* Manage Cloudflare DNS to register and unregister on start and stop (useful if you do not have a load balancer on top of Traefik). When you're running on premise environment, one thing is to make round robin on you physical hosts. This way, your ingress services are redirected to this round robin DNS name to make it distributed. That mean if a node reboot, you're going to miss on 1 node on X. To avoid that, when a traefik is going to be shutdown, it automatically pull off this node from the round robin pool. This way, it ensures, no miss will occur. Then, when it start again, it puts the node back in in the round robin pool and check its presence against several public DNS servers to ensure of its availability.

# Use this chart

1. First of all, deploy Consul.
2. Configure the value.yaml file to adapt to your needs
3. Deploy this chart :)

Feel free to make pull requests
