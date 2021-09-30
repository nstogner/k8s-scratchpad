# gRPC

Example gRPC setup on Kubernetes.

## Deploy

```sh
# Create cluster
kind create cluster --config=./kind.yaml --name grpc-example

# Deploy NGINX Ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

kubectl apply -f ./tls/secret.yaml
kubectl apply -f ./server/manifest.yaml
```

## Connect

Setup `127.0.0.1 greeter.sandbox` in `/etc/hosts`.

```sh
grpcurl --insecure -d '{"name":"nick"}' greeter.sandbox:443 helloworld.Greeter/SayHello
```

## Cleanup

```sh
kind delete cluster --name grpc-example
```

