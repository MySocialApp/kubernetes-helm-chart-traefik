# Kubernetes Helm Chart for Treafik HA

You can find here a helm chart we're using at [MySocialApp](https://mysocialapp.io) (iOS and Android social app builder - SaaS)

[Traefik](https://traefik.io/) in HA mode require to store its configuration into a distributed KV store. The current recommendation is using [Consul](https://www.consul.io/).

It you want to use [let's encrypt](https://letsencrypt.org/) to generate certificates, it will also be required. We made a [Consul chart](https://github.com/MySocialApp/kubernetes-helm-chart-consul) for it or you can use another one.

We made this chart because we want to get rid of manually managing bootstraping onto consul and have let's encrypt support with DNS challenge.

# What does this cahrt do

* Deploy traefik
* Boostrap traefik configuration inside consul kv store
* Manage let's encrypt certificates with DNS challenge on Cloudflare

# Use this chart

1. First of all, deploy Consul.
2. Configure the value.yaml file to adapt to your needs
3. Deploy this chart :)

Feel free to make pull requests
