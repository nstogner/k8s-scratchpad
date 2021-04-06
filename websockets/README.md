# Websockets on Kubernetes

## Deploy

```sh
# Create cluster
kind create cluster --config=./kind.yaml

# Deploy NGINX Ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

# Build app image
cd app/
docker build . -t wsapp:v1
kind load docker-image wsapp:v1
cd ..

# Deploy app
kubectl apply -f ./workload.yaml
```

## Connect

Open browser to [http://localhost:80].

In console:

```js
myws = new WebSocket("ws://localhost:80")

myws.onerror = function (e) {
  console.log("err -->", e);
}

myws.onclose = function (e) {
  console.log("close -->", e);
}

myws.onmessage = function (e) {
  console.log("received -->", e);
}

myws.onopen = function (e) {
  myws.send("hey");
}
```

## Cleanup

```sh
kind delete cluster
```

