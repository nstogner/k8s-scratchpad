# E2E NGINX to Service HTTPS

## Deploy

Create a local cluster.

```sh
# Create cluster
kind create cluster --config=./kind.yaml

# Deploy NGINX Ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
```

Deploy the app.

```sh
kubectl apply -f ./app/deployment.yaml
kubectl apply -f ./app/service.yaml
```

Enable SSL passthrough on NGINX.

```sh
kubectl edit -n ingress-nginx deployments.apps ingress-nginx-controller

# Add flag to nginx container:
# --enable-ssl-passthrough
```

Add `foo.com` to `/etc/hosts`:

```
127.0.0.1   foo.com
```

### Configuration 1: Double Termination

In this configuration, SSL is terminated at NGINX which re-establishes a HTTPS request to the service.

```sh
kubectl apply -f ./app/ingress-ssl-termination.yaml
```

Curl the service.

```sh
curl -vk https://foo.com
```

Note the certificate information (the default certificate served by the NGINX ingress controller):

```
* Server certificate:
*  subject: O=Acme Co; CN=Kubernetes Ingress Controller Fake Certificate
*  start date: Feb 11 20:03:59 2022 GMT
*  expire date: Feb 11 20:03:59 2023 GMT
*  issuer: O=Acme Co; CN=Kubernetes Ingress Controller Fake Certificate
*  SSL certificate verify result: unable to get local issuer certificate (20), continuing anyway.
```

### Configuration 2: Single Termination (SSL Passthrough)

In this configuration SSL is only terminated at the service.

```sh
kubectl apply -f ./app/ingress-ssl-passthrough.yaml
```

Curl the service.

```sh
curl -vk https://foo.com
```

Note the certificate information (the certificate served by the service - a self-signed cert which is baked into the app's container image):

```
* Server certificate:
*  subject: C=US; ST=NC; L=Raleigh; O=NA; OU=NA; CN=hello-go-api
*  start date: Feb 11 18:51:51 2022 GMT
*  expire date: Feb  9 18:51:51 2032 GMT
*  issuer: C=US; ST=NC; L=Raleigh; O=NA; OU=NA; CN=hello-go-api
*  SSL certificate verify result: self signed certificate (18), continuing anyway.
```

