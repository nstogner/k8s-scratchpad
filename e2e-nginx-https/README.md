# End to End HTTPS: Client --> NGINX --> App

## Deploy

Create a local cluster using [kind](https://kind.sigs.k8s.io/).

```sh
kind create cluster --config=./kind.yaml
```

Deploy the NGINX Ingress controller.

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
```

Upload certificates to Kubernetes.

```sh
kubectl apply -f ./ssl/app-tls.yaml
kubectl apply -f ./ssl/nginx-tls.yaml
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

```
Client--(SSL Term)NGINX-->(SSL Term)App
```

In this configuration, SSL is terminated at NGINX which re-establishes a HTTPS request to the service.

```sh
kubectl apply -f ./app/ingress-ssl-termination.yaml
```

Curl the service.

```sh
curl --cacert ./ssl/ca.crt -v https://foo.com
```

Note the certificate information (the certificate served by NGINX includes `L=San Nginxisco`):

```
* Server certificate:
*  subject: C=US; ST=California; L=San Nginxisco; O=Foo; OU=Foo Devs; CN=foo.com
```

### Configuration 2: Single Termination (SSL Passthrough)

```
Client--NGINX-->(SSL Term)App
```

In this configuration SSL is only terminated at the service.

```sh
kubectl apply -f ./app/ingress-ssl-passthrough.yaml
```

Curl the service.

```sh
curl --cacert ./ssl/ca.crt -v https://foo.com
```

Note the certificate information (the certificate served by the app includes `L=San Appsisco`):

```
* Server certificate:
*  subject: C=US; ST=California; L=San Appsisco; O=Foo; OU=Foo Devs; CN=foo.com
```

## Performance

Performance results can be seen in `perf/`. They were generated with [vegeta](https://github.com/tsenart/vegeta).

```sh
echo "GET https://foo.com" | vegeta attack --duration=5s --root-certs ./ssl/ca.crt | tee results.bin | vegeta report
```

## Notes

The Helm chart for NGINX can be installed with the following flag to enable SSL passthrough.

```
--set controller.extraArgs.enable-ssl-passthrough=""
```

