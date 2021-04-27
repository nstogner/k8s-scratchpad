# Egressing Ingress

Setup an ingress controller to send traffic to a Service of type ExternalName.

## Deploy

```sh
# Create cluster
kind create cluster --config=./kind.yaml

# Deploy NGINX Ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

# Deploy proxy configuration
kubectl apply -f ./httpbin.yaml
```

## Connect

Open browser to (http://localhost:80/get).

## References

- https://www.elvinefendi.com/2018/08/08/ingress-nginx-proxypass-to-external-upstream.html 

