# E2E NGINX to Service HTTPS

## Deploy

```sh
# Create cluster
kind create cluster --config=./kind.yaml

# Deploy NGINX Ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

# Deploy proxy configuration
kubectl apply -f ./app
```

Curl the service.

```sh
curl https://localhost -v -H 'Host: foo.com' -k
```
