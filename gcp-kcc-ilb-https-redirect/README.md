# GCP HTTPS ILB Redirects using Config Connector

Implementing HTTPS redirects for GCP HTTP(S) Load Balancers on GKE is not currently handled by the built-in GCE Ingress Controller.

Use [Config Connector](https://cloud.google.com/config-connector/docs/overview) to apply [the resources needed](https://cloud.google.com/load-balancing/docs/l7-internal/setting-up-http-to-https-redirect) to implement a HTTP->HTTPS redirect for ILBs on GCP.

## Guide

Create a GKE Cluster with Config Connector enabled.

Create a [self-managed ssl certificate](https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs) named `foo-cert`.

Update `my-project` in [config-connector.yaml](./config-connector.yaml) to be your project.

Apply all manifests.

