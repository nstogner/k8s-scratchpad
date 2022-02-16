set -e

# CA

openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes \
      -key ca.key -subj "/CN=foo/C=US/L=CALIFORNIA" \
      -days 1825 -out ca.crt

# App

openssl genrsa -out app-server.key 2048

cat > app-csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = US
ST = California
L = San Appsisco
O = Foo
OU = Foo Devs
CN = foo.com

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = foo
DNS.2 = foo.com
IP.1 = 127.0.0.1
IP.2 = 127.0.0.2

EOF

openssl req -new -key app-server.key -out app-server.csr -config app-csr.conf

openssl x509 -req -in app-server.csr -CA ca.crt -CAkey ca.key \
-CAcreateserial -out app-server.crt -days 10000 \
-extfile app-csr.conf

kubectl create secret tls app-tls \
  --cert=app-server.crt \
  --key=app-server.key \
  --dry-run=client \
  -oyaml > app-tls.yaml

# Nginx

openssl genrsa -out nginx-server.key 2048

cat > nginx-csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = US
ST = California
L = San Nginxisco
O = Foo
OU = Foo Devs
CN = foo.com

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = foo
DNS.2 = foo.com
IP.1 = 127.0.0.1
IP.2 = 127.0.0.2

EOF

openssl req -new -key nginx-server.key -out nginx-server.csr -config nginx-csr.conf

openssl x509 -req -in nginx-server.csr -CA ca.crt -CAkey ca.key \
-CAcreateserial -out nginx-server.crt -days 10000 \
-extfile nginx-csr.conf

kubectl create secret tls nginx-tls \
  --cert=nginx-server.crt \
  --key=nginx-server.key \
  --dry-run=client \
  -oyaml > nginx-tls.yaml
