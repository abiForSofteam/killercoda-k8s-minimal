#!/bin/bash
# Setup background - création de l'environnement défectueux

# Attendre que le cluster soit prêt
while ! kubectl get nodes | grep -q "Ready"; do
  sleep 5
done

# Créer le namespace dédié
kubectl create namespace exo2-subpath 2>/dev/null || true

# Créer la ConfigMap avec un nginx.conf personnalisé
kubectl create configmap nginx-custom-conf \
  --from-literal=nginx.conf='
user  nginx;
worker_processes  auto;
error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;
        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }
    }
}
' \
  -n exo2-subpath 2>/dev/null || true

# Créer le Pod DÉFECTUEUX (sans subPath — c'est le bug volontaire)
kubectl apply -f - -n exo2-subpath <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx-subpath
  namespace: exo2-subpath
  labels:
    app: nginx
    exercice: exo2
spec:
  containers:
  - name: nginx
    image: nginx:1.27
    volumeMounts:
    - name: nginx-config-vol
      mountPath: /etc/nginx/
      readOnly: true
  volumes:
  - name: nginx-config-vol
    configMap:
      name: nginx-custom-conf
EOF
